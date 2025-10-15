<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Area;
use App\Models\AreaCleaningTask;
use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AreaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Area::with(['creator:id,name', 'cleaningTasks']);

            // Search functionality
            if ($request->has('search') && !empty($request->search)) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('description', 'like', "%{$search}%")
                      ->orWhere('room_number', 'like', "%{$search}%");
                });
            }

            // Filter by floor
            if ($request->has('floor') && !empty($request->floor)) {
                $query->where('floor', $request->floor);
            }

            $areas = $query->orderBy('created_at', 'desc')->get();

            // Transform data untuk frontend
            $transformedAreas = $areas->map(function ($area) {
                return [
                    'id' => $area->id,
                    'name' => $area->name,
                    'lantai' => $area->floor,
                    'nomorRuangan' => $area->room_number,
                    'keterangan' => $area->description,
                    'kebersihan' => $area->kebersihan, // default items
                    'isActive' => true, // default active
                    'reportCount' => $area->report_count,
                    'createdAt' => $area->created_at->toISOString(),
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Areas retrieved successfully',
                'data' => $transformedAreas
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve areas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'lantai' => 'required|string|max:10',
                'nomorRuangan' => 'required|string|max:50',
                'keterangan' => 'required|string',
                'kebersihan' => 'required|array|min:1',
                'kebersihan.*' => 'string|max:255'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $area = Area::create([
                'name' => $request->name,
                'floor' => $request->lantai,
                'room_number' => $request->nomorRuangan,
                'description' => $request->keterangan,
                'created_by' => 1, // Default user ID untuk sekarang
            ]);

            // Simpan cleaning tasks
            if ($request->has('kebersihan') && is_array($request->kebersihan)) {
                foreach ($request->kebersihan as $taskName) {
                    AreaCleaningTask::create([
                        'area_id' => $area->id,
                        'task_name' => $taskName,
                        'is_required' => true, // Default semua task required
                    ]);
                }
            }

            // Reload area dengan cleaning tasks
            $area->load('cleaningTasks');

            return response()->json([
                'success' => true,
                'message' => 'Area created successfully',
                'data' => [
                    'id' => $area->id,
                    'name' => $area->name,
                    'lantai' => $area->floor,
                    'nomorRuangan' => $area->room_number,
                    'keterangan' => $area->description,
                    'kebersihan' => $area->kebersihan, // Ambil dari database
                    'isActive' => true,
                    'reportCount' => 0,
                    'createdAt' => $area->created_at->toISOString(),
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create area',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id): JsonResponse
    {
        try {
            $area = Area::with(['creator:id,name', 'cleaningTasks'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Area retrieved successfully',
                'data' => [
                    'id' => $area->id,
                    'name' => $area->name,
                    'lantai' => $area->floor,
                    'nomorRuangan' => $area->room_number,
                    'keterangan' => $area->description,
                    'kebersihan' => $area->kebersihan,
                    'isActive' => true,
                    'reportCount' => $area->report_count,
                    'createdAt' => $area->created_at->toISOString(),
                    'creator' => $area->creator,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Area not found',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id): JsonResponse
    {
        try {
            $area = Area::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'lantai' => 'required|string|max:10',
                'nomorRuangan' => 'required|string|max:50',
                'keterangan' => 'required|string',
                'kebersihan' => 'required|array|min:1',
                'kebersihan.*' => 'string|max:255'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $area->update([
                'name' => $request->name,
                'floor' => $request->lantai,
                'room_number' => $request->nomorRuangan,
                'description' => $request->keterangan,
            ]);

            // Update cleaning tasks
            if ($request->has('kebersihan') && is_array($request->kebersihan)) {
                // Hapus semua cleaning tasks lama
                $area->cleaningTasks()->delete();
                
                // Tambahkan cleaning tasks baru
                foreach ($request->kebersihan as $taskName) {
                    AreaCleaningTask::create([
                        'area_id' => $area->id,
                        'task_name' => $taskName,
                        'is_required' => true,
                    ]);
                }
            }

            // Reload area dengan cleaning tasks
            $area->load('cleaningTasks');

            return response()->json([
                'success' => true,
                'message' => 'Area updated successfully',
                'data' => [
                    'id' => $area->id,
                    'name' => $area->name,
                    'lantai' => $area->floor,
                    'nomorRuangan' => $area->room_number,
                    'keterangan' => $area->description,
                    'kebersihan' => $area->kebersihan, // Ambil dari database
                    'isActive' => true,
                    'reportCount' => $area->report_count,
                    'createdAt' => $area->created_at->toISOString(),
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update area',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id): JsonResponse
    {
        try {
            $area = Area::findOrFail($id);
            $area->delete();

            return response()->json([
                'success' => true,
                'message' => 'Area deleted successfully'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete area',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get area statistics
     */
    public function statistics(): JsonResponse
    {
        try {
            $total = Area::count();
            $active = $total; // Semua area active untuk sekarang
            $inactive = 0;
            $totalReports = 0; // Nanti akan dihubungkan dengan tabel reports

            return response()->json([
                'success' => true,
                'message' => 'Statistics retrieved successfully',
                'data' => [
                    'total' => $total,
                    'active' => $active,
                    'inactive' => $inactive,
                    'totalReports' => $totalReports,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get cleaning tasks for a specific area
     */
    public function getCleaningTasks(string $areaId): JsonResponse
    {
        try {
            $area = Area::findOrFail($areaId);
            $cleaningTasks = AreaCleaningTask::where('area_id', $areaId)->get();

            return response()->json([
                'success' => true,
                'message' => 'Cleaning tasks retrieved successfully',
                'data' => $cleaningTasks->map(function ($task) {
                    return [
                        'id' => $task->id,
                        'area_id' => $task->area_id,
                        'task_name' => $task->task_name,
                        'description' => $task->task_name, // Use task_name as description for now
                        'is_required' => $task->is_required,
                        'is_completed' => false, // Default to false, will be set by user
                    ];
                })
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve cleaning tasks',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Get weekly summary for reports
     */
    public function getWeeklySummary(): JsonResponse
    {
        try {
            // Get current week's date range
            $startOfWeek = Carbon::now()->startOfWeek();
            $endOfWeek = Carbon::now()->endOfWeek();

            // Count reports by status for this week
            $selesai = Report::where('status', 'approved')
                ->whereBetween('created_at', [$startOfWeek, $endOfWeek])
                ->count();

            $menunggu = Report::where('status', 'pending')
                ->whereBetween('created_at', [$startOfWeek, $endOfWeek])
                ->count();

            $ditolak = Report::where('status', 'rejected')
                ->whereBetween('created_at', [$startOfWeek, $endOfWeek])
                ->count();

            // Also get all-time counts for debugging
            $selesaiTotal = Report::where('status', 'approved')->count();
            $menungguTotal = Report::where('status', 'pending')->count();
            $ditolakTotal = Report::where('status', 'rejected')->count();

            $weeklySummary = [
                'selesai' => $selesai,
                'menunggu' => $menunggu,
                'ditolak' => $ditolak,
                'debug' => [
                    'start_of_week' => $startOfWeek->toDateTimeString(),
                    'end_of_week' => $endOfWeek->toDateTimeString(),
                    'total_selesai' => $selesaiTotal,
                    'total_menunggu' => $menungguTotal,
                    'total_ditolak' => $ditolakTotal,
                ]
            ];

            return response()->json([
                'success' => true,
                'message' => 'Weekly summary retrieved successfully',
                'data' => $weeklySummary
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve weekly summary',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get cleaning reports for admin
     */
    public function getCleaningReports(): JsonResponse
    {
        try {
            // Get all reports with related data
            $reports = Report::with(['user:id,name', 'area:id,name', 'photos', 'tasks.cleaningTask:id,task_name'])
                ->orderBy('created_at', 'desc')
                ->get();

            // Format the reports data
            $formattedReports = $reports->map(function ($report) {
                return [
                    'id' => $report->id,
                    'title' => $report->title,
                    'submission_date' => $report->created_at->format('Y-m-d\TH:i:s'),
                    'status' => $report->status,
                    'user' => [
                        'id' => $report->user->id,
                        'name' => $report->user->name,
                    ],
                    'area' => [
                        'id' => $report->area->id,
                        'name' => $report->area->name,
                    ],
                    'description' => $report->description ?? '',
                    'admin_notes' => $report->admin_notes,
                    'photos' => $report->photos->map(function ($photo) {
                        return [
                            'id' => $photo->id,
                            'url' => $photo->photo_url,
                            'order' => $photo->order,
                        ];
                    })->toArray(),
                    'tasks' => $report->tasks->map(function ($task) {
                        return [
                            'id' => $task->cleaning_task_id,
                            'task_name' => $task->cleaningTask->task_name ?? 'Unknown Task',
                            'is_completed' => true,
                        ];
                    })->toArray(),
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Reports retrieved successfully',
                'data' => $formattedReports
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve reports',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Submit cleaning report
     */
    public function submitCleaningReport(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'area_id' => 'required|integer|exists:areas,id',
                'area_name' => 'required|string',
                'lantai' => 'required|string',
                'nomor_ruangan' => 'required|string',
                'completed_task_ids' => 'required|string', // JSON string
                'catatan_pembersihan' => 'required|string',
                'photos.*' => 'image|mimes:jpeg,png,jpg|max:5120', // 5MB max
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            // For now, just return success since we don't have the reports table yet
            // In real implementation, you would save to database here
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan pembersihan berhasil dikirim',
                'data' => [
                    'area_id' => $request->area_id,
                    'status' => 'pending',
                    'submitted_at' => now()
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to submit cleaning report',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function submitEmergencyReport(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'area_id' => 'required|exists:areas,id',
                'lantai' => 'required|string',
                'no_ruangan' => 'required|string',
                'catatan' => 'required|string',
                'photos' => 'array|max:5',
                'photos.*' => 'file|mimes:jpeg,png,jpg|max:5120' // 5MB max
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tidak valid',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Get user_id from request or use default for testing
            $userId = $request->input('user_id', 1); // TODO: Get from auth

            // Create emergency report in reports table
            $report = Report::create([
                'area_id' => $request->area_id,
                'user_id' => $userId,
                'title' => 'Laporan Darurat - ' . ($request->area_name ?? 'Area'),
                'description' => $request->catatan,
                'status' => 'pending', // Emergency reports start as pending
                'submission_date' => now(),
            ]);

            // Handle photo uploads
            if ($request->hasFile('photos')) {
                $photos = $request->file('photos');
                foreach ($photos as $index => $photo) {
                    // Store photo in storage/app/public/reports
                    $path = $photo->store('reports', 'public');
                    
                    // Save to report_photos table
                    \App\Models\ReportPhoto::create([
                        'report_id' => $report->id,
                        'photo_path' => $path,
                        'original_name' => $photo->getClientOriginalName(),
                        'file_size' => $photo->getSize(),
                        'mime_type' => $photo->getMimeType(),
                        'order' => $index + 1,
                    ]);
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Laporan darurat berhasil dikirim dan tersimpan',
                'data' => [
                    'report_id' => $report->id,
                    'area_id' => $report->area_id,
                    'title' => $report->title,
                    'status' => $report->status,
                    'photos_count' => $request->hasFile('photos') ? count($request->file('photos')) : 0,
                    'submitted_at' => $report->created_at->format('Y-m-d H:i:s')
                ]
            ]);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak valid',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get reports for specific user (for user's riwayat/history)
     */
    public function getUserReports($userId): JsonResponse
    {
        try {
            // Get all reports from specific user with related data
            $reports = Report::with(['user:id,name', 'area:id,name', 'photos'])
                ->where('user_id', $userId)
                ->orderBy('created_at', 'desc')
                ->get();

            // Format the reports data
            $formattedReports = $reports->map(function ($report) {
                return [
                    'id' => $report->id,
                    'title' => $report->title,
                    'submission_date' => $report->created_at->format('Y-m-d\TH:i:s'),
                    'status' => $report->status,
                    'user' => [
                        'id' => $report->user->id,
                        'name' => $report->user->name,
                    ],
                    'area' => [
                        'id' => $report->area->id,
                        'name' => $report->area->name,
                    ],
                    'description' => $report->description ?? '',
                    'admin_notes' => $report->admin_notes,
                    'photos' => $report->photos->map(function ($photo) {
                        return [
                            'id' => $photo->id,
                            'url' => $photo->url, // Menggunakan accessor dari model
                            'order' => $photo->order,
                        ];
                    })->toArray(),
                    'created_at' => $report->created_at->format('Y-m-d\TH:i:s'),
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'User reports retrieved successfully',
                'data' => $formattedReports
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve user reports',
                'error' => $e->getMessage()
            ], 500);
        }
    }


}

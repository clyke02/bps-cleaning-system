<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Area;
use App\Models\AreaCleaningTask;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

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
            // Get reports from this week (assuming we have CleaningReport model)
            // For now, return dummy data since we don't have the reports table yet
            $weeklySummary = [
                'Selesai' => 7,
                'Menunggu' => 3,
                'Ditolak' => 2,
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
            // Dummy reports data with task IDs that reference area_cleaning_tasks
            $reportsData = [
                [
                    'id' => 1,
                    'title' => 'Lantai 1 - Laporan Pembersihan - Ruang Kerja',
                    'submission_date' => '2025-10-13T12:53:02',
                    'status' => 'pending',
                    'user' => [
                        'id' => 1,
                        'name' => 'Super Petugas'
                    ],
                    'area' => [
                        'id' => 3,
                        'name' => 'Ruang Kerja'
                    ],
                    'description' => 'Beres bos',
                    'admin_notes' => null,
                    'photos' => [],
                    'completed_task_ids' => [5, 6], // Task IDs from area_cleaning_tasks
                ],
                [
                    'id' => 2,
                    'title' => 'Lantai 2 - Laporan Pembersihan - Kamar Mandi',
                    'submission_date' => '2025-10-13T14:15:00',
                    'status' => 'pending',
                    'user' => [
                        'id' => 1,
                        'name' => 'Super Petugas'
                    ],
                    'area' => [
                        'id' => 5,
                        'name' => 'Kamar Mandi'
                    ],
                    'description' => 'Coba di cek',
                    'admin_notes' => null,
                    'photos' => [],
                    'completed_task_ids' => [1, 2, 3], // Task IDs from area_cleaning_tasks
                ]
            ];

            // Fetch actual task names from area_cleaning_tasks for each report
            $reports = [];
            foreach ($reportsData as $reportData) {
                $taskIds = $reportData['completed_task_ids'];
                
                // Get actual task names from area_cleaning_tasks table
                $tasks = AreaCleaningTask::whereIn('id', $taskIds)->get(['id', 'task_name']);
                
                $reportData['tasks'] = $tasks->map(function ($task) {
                    return [
                        'id' => $task->id,
                        'task_name' => $task->task_name,
                        'is_completed' => true
                    ];
                })->toArray();
                
                // Remove completed_task_ids as it's now in tasks array
                unset($reportData['completed_task_ids']);
                
                $reports[] = $reportData;
            }

            return response()->json([
                'success' => true,
                'message' => 'Cleaning reports retrieved successfully',
                'data' => $reports
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve cleaning reports',
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


}

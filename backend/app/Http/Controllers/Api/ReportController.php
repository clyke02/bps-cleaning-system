<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportPhoto;
use App\Models\ReportTask;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ReportController extends Controller
{
    /**
     * Store a newly created report with photos
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'area_id' => 'required|exists:areas,id',
                'user_id' => 'required|exists:users,id',
                'area_name' => 'required|string',
                'lantai' => 'required|string',
                'nomor_ruangan' => 'required|string',
                'completed_task_ids' => 'required|json',
                'catatan_pembersihan' => 'required|string',
                'photos' => 'required|array|min:1|max:5',
                'photos.*' => 'image|mimes:jpeg,jpg,png|max:5120', // Max 5MB per file
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            // Create report
            $report = Report::create([
                'area_id' => $request->area_id,
                'user_id' => $request->user_id,
                'title' => "Laporan Pembersihan - {$request->area_name}",
                'description' => $request->catatan_pembersihan,
                'status' => 'pending',
                'submission_date' => now(), // Save full datetime
            ]);

            // Save completed tasks with cleaning_task_id reference
            $completedTaskIds = json_decode($request->completed_task_ids, true);
            if (is_array($completedTaskIds)) {
                foreach ($completedTaskIds as $taskId) {
                    // Get actual task from area_cleaning_tasks table
                    $areaTask = \App\Models\AreaCleaningTask::find($taskId);
                    
                    if ($areaTask) {
                        ReportTask::create([
                            'report_id' => $report->id,
                            'cleaning_task_id' => $areaTask->id, // Save the cleaning_task_id
                            'task_name' => $areaTask->task_name, // Also save task name for convenience
                            'is_completed' => true,
                            'notes' => null, // Notes can be added later if needed
                        ]);
                    }
                }
            }

            // Upload and save photos
            if ($request->hasFile('photos')) {
                $photos = $request->file('photos');
                foreach ($photos as $index => $photo) {
                    // Generate unique filename
                    $filename = time() . '_' . $index . '_' . uniqid() . '.' . $photo->getClientOriginalExtension();
                    
                    // Store in public/storage/report_photos
                    $path = $photo->storeAs('report_photos', $filename, 'public');

                    // Save photo record
                    ReportPhoto::create([
                        'report_id' => $report->id,
                        'photo_path' => $path,
                        'original_name' => $photo->getClientOriginalName(),
                        'file_size' => $photo->getSize(),
                        'mime_type' => $photo->getMimeType(),
                        'order' => $index,
                    ]);
                }
            }

            // Update daily assignment - set report_id but keep status as 'pending' (IN REVIEW)
            // Status will change to 'completed' or 'rejected' when admin reviews the report
            $today = now()->toDateString();
            $assignment = \App\Models\DailyAssignment::where('area_id', $request->area_id)
                ->where('assignment_date', $today)
                ->where('status', 'pending')
                ->first();

            if ($assignment) {
                $assignment->update([
                    'status' => 'pending', // Keep as pending until admin reviews
                    'report_id' => $report->id,
                ]);

                if (config('app.debug')) {
                    Log::info('Assignment report submitted (in review)', [
                        'assignment_id' => $assignment->id,
                        'area_id' => $request->area_id,
                        'submitted_by_user_id' => $request->user_id,
                        'report_id' => $report->id,
                    ]);
                }
            }

            DB::commit();

            // Load relationships
            $report->load(['photos', 'tasks', 'area', 'user']);

            // Send notification to all admins
            $user = \App\Models\User::find($request->user_id);
            if ($user) {
                \App\Services\FCMService::sendToRole(
                    'admin',
                    'Laporan Baru Masuk',
                    "{$user->name} mengirim laporan pembersihan {$request->area_name}",
                    ['type' => 'new_report', 'report_id' => $report->id]
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil dikirim',
                'data' => [
                    'id' => $report->id,
                    'area_id' => $request->area_id,
                    'area_name' => $request->area_name,
                    'lantai' => $request->lantai,
                    'nomor_ruangan' => $request->nomor_ruangan,
                    'status' => $report->status,
                    'submission_date' => $report->submission_date,
                    'photos_count' => $report->photos->count(),
                    'tasks_count' => $report->tasks->count(),
                    'assignment_updated' => $assignment ? true : false,
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            
            return response()->json([
                'success' => false,
                'message' => 'Failed to create report',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all reports
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Report::with(['photos', 'tasks', 'area', 'user']);

            // Filter by status
            if ($request->has('status')) {
                $query->where('status', $request->status);
            }

            // Filter by user (for petugas to see their own reports)
            if ($request->has('user_id')) {
                $query->where('user_id', $request->user_id);
            }

            $reports = $query->orderBy('created_at', 'desc')->get();

            // Transform response for frontend
            $formattedReports = $reports->map(function ($report) {
                return [
                    'id' => $report->id,
                    'title' => $report->title,
                    'description' => $report->description,
                    'status' => $report->status,
                    'submission_date' => $report->submission_date,
                    'user' => [
                        'id' => $report->user->id,
                        'name' => $report->user->name,
                        'username' => $report->user->username,
                    ],
                    'area' => [
                        'id' => $report->area->id,
                        'name' => $report->area->name,
                        'lantai' => $report->area->lantai,
                        'nomor_ruangan' => $report->area->nomor_ruangan,
                    ],
                    'tasks' => $report->tasks->map(function ($task) {
                        return [
                            'id' => $task->id,
                            'task_name' => $task->task_name,
                            'is_completed' => $task->is_completed,
                            'notes' => $task->notes,
                        ];
                    }),
                    'photos' => $report->photos->map(function ($photo) {
                        // Generate full URL manually to avoid file:// protocol issue
                        $baseUrl = request()->getSchemeAndHttpHost(); // Get http://10.0.2.2:8000
                        return [
                            'id' => $photo->id,
                            'photo_path' => $baseUrl . '/storage/' . $photo->photo_path,
                        ];
                    }),
                    'admin_notes' => $report->admin_notes,
                    'reviewed_at' => $report->reviewed_at,
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
     * Get single report
     */
    public function show(string $id): JsonResponse
    {
        try {
            $report = Report::with(['photos', 'tasks', 'area', 'user', 'reviewer'])
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Report retrieved successfully',
                'data' => $report
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Report not found',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Update report status (for admin)
     */
    public function updateStatus(Request $request, string $id): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'status' => 'required|in:pending,approved,rejected',
                'admin_notes' => 'nullable|string',
                'rating' => 'nullable|integer|min:1|max:5',
                'reviewed_by' => 'required|exists:users,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $report = Report::findOrFail($id);
            
            $report->update([
                'status' => $request->status,
                'admin_notes' => $request->admin_notes,
                'rating' => $request->rating,
                'reviewed_by' => $request->reviewed_by,
                'reviewed_at' => now(),
            ]);

            // Update daily assignment based on approval/rejection
            $assignment = \App\Models\DailyAssignment::where('report_id', $report->id)->first();
            if ($assignment) {
                if ($request->status === 'approved') {
                    // Approved: mark assignment as completed
                    $assignment->update(['status' => 'completed']);
                } elseif ($request->status === 'rejected') {
                    // Rejected: mark as rejected and clear report_id so user can re-submit
                    $assignment->update([
                        'status' => 'rejected',
                        'report_id' => null,
                    ]);
                }
                
                if (config('app.debug')) {
                    Log::info('Assignment status updated after review', [
                        'assignment_id' => $assignment->id,
                        'report_id' => $report->id,
                        'new_status' => $assignment->status,
                    ]);
                }
            }

            // Load relationships for complete response
            $report->load(['photos', 'tasks', 'area', 'user', 'reviewer']);

            // Send notification to report owner
            $statusText = $request->status === 'approved' ? 'disetujui' : 'ditolak';
            if ($report->user && $report->user->fcm_token) {
                \App\Services\FCMService::sendToUser(
                    $report->user->fcm_token,
                    'Laporan ' . ucfirst($statusText),
                    "Laporan pembersihan {$report->area->name} telah $statusText oleh admin",
                    ['type' => 'report_reviewed', 'report_id' => $report->id, 'status' => $request->status]
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Report status updated successfully',
                'data' => $report
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update report status',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

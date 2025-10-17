<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

/**
 * Optimized Report Controller
 * - Implements caching strategy
 * - Pagination for better performance
 * - Reduced database queries with eager loading
 */
class OptimizedReportController extends Controller
{
    /**
     * Get reports with pagination and caching
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $perPage = $request->input('per_page', 20); // Default 20 items per page
            $status = $request->input('status');
            $userId = $request->input('user_id');
            $page = $request->input('page', 1);

            // Create cache key based on filters
            $cacheKey = "reports_page_{$page}_status_{$status}_user_{$userId}_per_{$perPage}";

            // Cache for 5 minutes
            $reports = Cache::remember($cacheKey, 300, function () use ($perPage, $status, $userId) {
                $query = Report::with([
                    'user:id,name,username',
                    'area:id,name,floor,room_number',
                    'tasks:id,report_id,task_name,is_completed',
                    'photos:id,report_id,photo_path'
                ]);

                // Apply filters
                if ($status) {
                    $query->where('status', $status);
                }

                if ($userId) {
                    $query->where('user_id', $userId);
                }

                // Paginate
                return $query
                    ->select('id', 'title', 'description', 'status', 'submission_date', 'user_id', 'area_id', 'admin_notes', 'reviewed_at')
                    ->orderBy('created_at', 'desc')
                    ->paginate($perPage);
            });

            // Transform for frontend
            $formattedReports = $reports->map(function ($report) {
                $baseUrl = request()->getSchemeAndHttpHost();
                
                return [
                    'id' => $report->id,
                    'title' => $report->title,
                    'description' => $report->description,
                    'status' => $report->status,
                    'submission_date' => $report->submission_date,
                    'user' => [
                        'id' => $report->user->id,
                        'name' => $report->user->name,
                        'username' => $report->user->username ?? '',
                    ],
                    'area' => [
                        'id' => $report->area->id,
                        'name' => $report->area->name,
                        'lantai' => $report->area->floor,
                        'nomor_ruangan' => $report->area->room_number,
                    ],
                    'tasks' => $report->tasks->map(fn($task) => [
                        'id' => $task->id,
                        'task_name' => $task->task_name,
                        'is_completed' => $task->is_completed,
                    ]),
                    'photos' => $report->photos->map(fn($photo) => [
                        'id' => $photo->id,
                        'photo_path' => $baseUrl . '/storage/' . $photo->photo_path,
                    ]),
                    'admin_notes' => $report->admin_notes,
                    'reviewed_at' => $report->reviewed_at,
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Reports retrieved successfully',
                'data' => $formattedReports,
                'meta' => [
                    'current_page' => $reports->currentPage(),
                    'total_pages' => $reports->lastPage(),
                    'per_page' => $reports->perPage(),
                    'total' => $reports->total(),
                ],
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
     * Get report statistics (cached)
     */
    public function statistics(): JsonResponse
    {
        try {
            $stats = Cache::remember('report_statistics', 600, function () {
                return [
                    'total' => Report::count(),
                    'pending' => Report::where('status', 'pending')->count(),
                    'approved' => Report::where('status', 'approved')->count(),
                    'rejected' => Report::where('status', 'rejected')->count(),
                    'today' => Report::whereDate('created_at', today())->count(),
                    'this_week' => Report::whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])->count(),
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $stats
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
     * Clear reports cache (call after create/update/delete)
     */
    public function clearCache(): void
    {
        Cache::forget('report_statistics');
        // Clear paginated caches
        foreach (range(1, 10) as $page) {
            Cache::forget("reports_page_{$page}_status__user__per_20");
        }
    }
}


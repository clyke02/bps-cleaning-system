<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DailyAssignment;
use App\Models\Area;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class DailyAssignmentController extends Controller
{
    /**
     * Get daily assignments for a user (SHARED MODE - all users see all areas for the day)
     */
    public function getUserAssignments(Request $request, $userId): JsonResponse
    {
        try {
            $date = $request->get('date', now()->toDateString());
            
            // SHARED MODE: Get all assignments for the date (not filtered by user_id)
            // All users can see and work on all areas
            $assignments = DailyAssignment::with(['area', 'report'])
                ->forDate($date)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Daily assignments retrieved successfully (shared mode)',
                'data' => $assignments,
                'date' => $date,
                'mode' => 'shared' // Indicator that assignments are shared
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve assignments',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create daily assignments for users (Admin only)
     */
    public function createAssignments(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_ids' => 'required|array',
                'user_ids.*' => 'exists:users,id',
                'area_ids' => 'required|array', 
                'area_ids.*' => 'exists:areas,id',
                'assignment_date' => 'required|date',
                'notes' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $created = [];
            $duplicates = [];

            foreach ($request->user_ids as $userId) {
                foreach ($request->area_ids as $areaId) {
                    // Check if assignment already exists
                    $existing = DailyAssignment::where('user_id', $userId)
                        ->where('area_id', $areaId)
                        ->where('assignment_date', $request->assignment_date)
                        ->first();

                    if ($existing) {
                        $duplicates[] = [
                            'user_id' => $userId,
                            'area_id' => $areaId,
                            'date' => $request->assignment_date
                        ];
                        continue;
                    }

                    $assignment = DailyAssignment::create([
                        'user_id' => $userId,
                        'area_id' => $areaId,
                        'assignment_date' => $request->assignment_date,
                        'notes' => $request->notes,
                        'status' => 'pending'
                    ]);

                    $created[] = $assignment;
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Assignments created successfully',
                'data' => [
                    'created' => count($created),
                    'duplicates' => count($duplicates),
                    'assignments' => $created
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create assignments',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Auto-generate daily assignments for today (SHARED MODE - 1 area = 1 assignment)
     * All users can work on any area, whoever completes it first marks it as done for everyone
     */
    public function generateDailyAssignments(): JsonResponse
    {
        try {
            $today = now()->toDateString();
            
            // Get first user with role 'user' as assignment owner (shared for all users)
            $firstUser = User::where('role', 'user')->first();
            
            if (!$firstUser) {
                return response()->json([
                    'success' => false,
                    'message' => 'No users found with role "user"',
                ], 404);
            }
            
            // Get all active areas
            $areas = Area::all();
            
            $created = 0;
            $skipped = 0;

            // Create 1 assignment per area (shared by all users)
            foreach ($areas as $area) {
                // Check if assignment already exists for today (for this area only)
                $existing = DailyAssignment::where('area_id', $area->id)
                    ->where('assignment_date', $today)
                    ->first();

                if ($existing) {
                    // Reset assignment for today regardless of its current status.
                    // When admin presses Generate, users must be able to report again
                    // for the new day so we clear report_id and set status to 'pending'.
                    try {
                        $existing->update([
                            'report_id' => null,
                            'status' => 'pending'
                        ]);
                        // Count as created since the assignment is effectively refreshed
                        $created++;
                    } catch (\Exception $e) {
                        // If update fails, skip and continue
                        $skipped++;
                    }

                    continue;
                }

                // Create shared assignment (user_id = first user, but accessible by all)
                DailyAssignment::create([
                    'user_id' => $firstUser->id,
                    'area_id' => $area->id,
                    'assignment_date' => $today,
                    'status' => 'pending'
                ]);

                $created++;
            }

            // Send notification to all users after creating assignments
            if ($created > 0) {
                \App\Services\FCMService::sendToRole(
                    'user',
                    'Tugas Harian Baru',
                    "Ada $created tugas pembersihan baru untuk hari ini",
                    ['type' => 'new_assignment', 'count' => $created]
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Daily assignments generated successfully (shared mode)',
                'data' => [
                    'created' => $created,
                    'skipped' => $skipped,
                    'date' => $today,
                    'mode' => 'shared' // Indicator that assignments are shared
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to generate daily assignments',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update assignment status when report is submitted
     */
    public function updateAssignmentStatus(Request $request, $assignmentId): JsonResponse
    {
        try {
            $assignment = DailyAssignment::findOrFail($assignmentId);
            
            $validator = Validator::make($request->all(), [
                'status' => 'required|in:pending,completed,missed',
                'report_id' => 'nullable|exists:reports,id'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $assignment->update([
                'status' => $request->status,
                'report_id' => $request->report_id
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Assignment status updated successfully',
                'data' => $assignment->load(['area', 'report'])
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update assignment status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mark overdue assignments as missed (run daily via scheduler)
     */
    public function markOverdueAsMissed(): JsonResponse
    {
        try {
            $yesterday = now()->subDay()->toDateString();
            
            $overdueCount = DailyAssignment::where('assignment_date', '<', now()->toDateString())
                ->where('status', 'pending')
                ->update(['status' => 'missed']);

            return response()->json([
                'success' => true,
                'message' => 'Overdue assignments marked as missed',
                'data' => ['marked_missed' => $overdueCount]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to mark overdue assignments',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get weekly report data for PDF export
     */
    public function getWeeklyReportData(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'year' => 'required|integer|min:2020|max:2030',
                'month' => 'required|integer|min:1|max:12',
                'week' => 'required|integer|min:1|max:4'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Calculate week dates
            $year = $request->year;
            $month = $request->month;
            $week = $request->week;
            
            $startOfMonth = Carbon::create($year, $month, 1);
            $startOfWeek = $startOfMonth->copy()->addWeeks($week - 1)->startOfWeek();
            $endOfWeek = $startOfWeek->copy()->endOfWeek();
            
            // Ensure we don't go beyond the month
            if ($endOfWeek->month > $month) {
                $endOfWeek = $startOfMonth->copy()->endOfMonth();
            }

            // Get assignments for the week
            $assignments = DailyAssignment::with(['user', 'area', 'report'])
                ->whereBetween('assignment_date', [$startOfWeek, $endOfWeek])
                ->orderBy('assignment_date', 'asc')
                ->get();

            // Group by user
            $reportData = $assignments->groupBy('user.name')->map(function ($userAssignments) {
                return [
                    'user' => $userAssignments->first()->user,
                    'assignments' => $userAssignments->groupBy('assignment_date')->map(function ($dateAssignments) {
                        return $dateAssignments->map(function ($assignment) {
                            return [
                                'area' => $assignment->area,
                                'status' => $assignment->status,
                                'report' => $assignment->report,
                                'completed_at' => $assignment->report?->created_at
                            ];
                        });
                    })
                ];
            });

            // Calculate summary
            $summary = [
                'total_assignments' => $assignments->count(),
                'completed' => $assignments->where('status', 'completed')->count(),
                'pending' => $assignments->where('status', 'pending')->count(),
                'missed' => $assignments->where('status', 'missed')->count(),
                'completion_rate' => $assignments->count() > 0 
                    ? round(($assignments->where('status', 'completed')->count() / $assignments->count()) * 100, 1) 
                    : 0
            ];

            return response()->json([
                'success' => true,
                'message' => 'Weekly report data retrieved successfully',
                'data' => [
                    'period' => [
                        'year' => $year,
                        'month' => $month,
                        'week' => $week,
                        'start_date' => $startOfWeek->toDateString(),
                        'end_date' => $endOfWeek->toDateString(),
                        'period_text' => "Minggu ke-{$week}, " . $startOfWeek->format('F Y')
                    ],
                    'summary' => $summary,
                    'assignments' => $assignments,
                    'report_data' => $reportData
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve weekly report data',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
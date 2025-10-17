<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\API\AreaController;
use App\Http\Controllers\Api\ReportController;

use App\Http\Controllers\Api\DailyAssignmentController;

Route::post('/login', [AuthController::class, 'login']);

// Temporary: Allow users API without auth for development
Route::apiResource('users', UserController::class);
Route::put('/users/{id}/change-password', [UserController::class, 'changePassword']);
Route::put('/users/{id}/fcm-token', [UserController::class, 'updateFCMToken']);

// Daily Assignments API routes
Route::get('/users/{userId}/assignments', [DailyAssignmentController::class, 'getUserAssignments']);
Route::post('/assignments', [DailyAssignmentController::class, 'createAssignments']);
Route::post('/assignments/generate-daily', [DailyAssignmentController::class, 'generateDailyAssignments']);
Route::put('/assignments/{assignmentId}/status', [DailyAssignmentController::class, 'updateAssignmentStatus']);
Route::post('/assignments/mark-overdue', [DailyAssignmentController::class, 'markOverdueAsMissed']);
Route::get('/weekly-report-data', [DailyAssignmentController::class, 'getWeeklyReportData']);

// Areas API routes
Route::apiResource('areas', AreaController::class);
Route::get('/areas-statistics', [AreaController::class, 'statistics']);
Route::get('/area-cleaning-tasks/{areaId}', [AreaController::class, 'getCleaningTasks']);
Route::get('/weekly-summary', [AreaController::class, 'getWeeklySummary']);
Route::get('/cleaning-reports', [AreaController::class, 'getCleaningReports']);
Route::post('/cleaning-reports', [AreaController::class, 'submitCleaningReport']);
Route::post('/emergency-reports', [AreaController::class, 'submitEmergencyReport']);
Route::get('/user-reports/{userId}', [AreaController::class, 'getUserReports']);

// Reports API routes (without auth for now)
Route::post('/cleaning-reports', [ReportController::class, 'store']);
Route::get('/cleaning-reports', [ReportController::class, 'index']);
Route::get('/cleaning-reports/{id}', [ReportController::class, 'show']);
Route::put('/cleaning-reports/{id}/status', [ReportController::class, 'updateStatus']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

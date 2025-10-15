<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\API\AreaController;
use App\Http\Controllers\Api\ReportController;

Route::post('/login', [AuthController::class, 'login']);

// Temporary: Allow users API without auth for development
Route::apiResource('users', UserController::class);

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

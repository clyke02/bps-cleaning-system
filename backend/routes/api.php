<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\API\AreaController;

Route::post('/login', [AuthController::class, 'login']);

// Temporary: Allow users API without auth for development
Route::apiResource('users', UserController::class);

// Areas API routes
Route::apiResource('areas', AreaController::class);
Route::get('/areas-statistics', [AreaController::class, 'statistics']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

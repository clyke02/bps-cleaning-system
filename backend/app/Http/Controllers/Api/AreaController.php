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
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Area extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'floor',
        'room_number',
        'description',
        'created_by',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function cleaningTasks()
    {
        return $this->hasMany(AreaCleaningTask::class);
    }

    // Untuk kompatibilitas dengan frontend yang menggunakan field lama
    public function getLantaiAttribute()
    {
        return $this->floor;
    }

    public function getNomorRuanganAttribute()
    {
        return $this->room_number;
    }

    public function getKeteranganAttribute()
    {
        return $this->description;
    }

    public function getKebersihanAttribute()
    {
        // Ambil cleaning tasks dari database
        $tasks = $this->cleaningTasks()->pluck('task_name')->toArray();
        
        // Jika tidak ada tasks di database, return default untuk kompatibilitas
        if (empty($tasks)) {
            return ['Pembersihan Umum', 'Penyapuan', 'Pel Lantai'];
        }
        
        return $tasks;
    }

    public function getReportCountAttribute()
    {
        // Untuk sementara return 0, nanti akan dihubungkan dengan tabel reports
        return 0;
    }
}
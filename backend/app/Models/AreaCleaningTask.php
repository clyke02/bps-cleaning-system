<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AreaCleaningTask extends Model
{
    use HasFactory;

    protected $fillable = [
        'area_id',
        'task_name',
        'is_required',
    ];

    protected $casts = [
        'is_required' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function area()
    {
        return $this->belongsTo(Area::class);
    }
}
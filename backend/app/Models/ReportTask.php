<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportTask extends Model
{
    use HasFactory;

    protected $fillable = [
        'report_id',
        'task_name',
        'is_completed',
        'notes',
    ];

    protected $casts = [
        'is_completed' => 'boolean',
    ];

    public function report()
    {
        return $this->belongsTo(Report::class);
    }
}

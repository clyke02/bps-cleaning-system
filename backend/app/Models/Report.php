<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
    use HasFactory;

    protected $fillable = [
        'area_id',
        'user_id',
        'title',
        'description',
        'status',
        'submission_date',
        'admin_notes',
        'rating',
        'reviewed_by',
        'reviewed_at',
    ];

    protected $casts = [
        'submission_date' => 'datetime', // Changed from 'date' to 'datetime' to include time
        'reviewed_at' => 'datetime',
    ];

    // Relationships
    public function area()
    {
        return $this->belongsTo(Area::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reviewer()
    {
        return $this->belongsTo(User::class, 'reviewed_by');
    }

    public function photos()
    {
        return $this->hasMany(ReportPhoto::class)->orderBy('order');
    }

    public function tasks()
    {
        return $this->hasMany(ReportTask::class);
    }
}

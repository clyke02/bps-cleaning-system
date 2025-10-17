<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DailyAssignment extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'area_id', 
        'assignment_date',
        'status',
        'report_id',
        'notes',
    ];

    protected $casts = [
        'assignment_date' => 'date',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function area()
    {
        return $this->belongsTo(Area::class);
    }

    public function report()
    {
        return $this->belongsTo(Report::class);
    }

    // Scopes
    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    public function scopeCompleted($query)
    {
        return $query->where('status', 'completed');
    }

    public function scopeMissed($query)
    {
        return $query->where('status', 'missed');
    }

    public function scopeForUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function scopeForDate($query, $date)
    {
        return $query->whereDate('assignment_date', $date);
    }

    public function scopeForWeek($query, $year, $week)
    {
        $startOfWeek = now()->setISODate($year, $week)->startOfWeek();
        $endOfWeek = now()->setISODate($year, $week)->endOfWeek();
        
        return $query->whereBetween('assignment_date', [$startOfWeek, $endOfWeek]);
    }

    public function scopeForMonth($query, $year, $month)
    {
        return $query->whereYear('assignment_date', $year)
                    ->whereMonth('assignment_date', $month);
    }

    // Helper methods
    public function isOverdue()
    {
        return $this->assignment_date < now()->toDateString() && $this->status === 'pending';
    }

    public function markAsCompleted($reportId = null)
    {
        $this->update([
            'status' => 'completed',
            'report_id' => $reportId,
        ]);
    }

    public function markAsMissed()
    {
        $this->update(['status' => 'missed']);
    }
}
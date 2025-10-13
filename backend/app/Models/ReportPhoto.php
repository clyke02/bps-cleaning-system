<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportPhoto extends Model
{
    use HasFactory;

    protected $fillable = [
        'report_id',
        'photo_path',
        'original_name',
        'file_size',
        'mime_type',
        'order',
    ];

    public function report()
    {
        return $this->belongsTo(Report::class);
    }

    // Get full URL of the photo
    public function getUrlAttribute()
    {
        return asset('storage/' . $this->photo_path);
    }
}

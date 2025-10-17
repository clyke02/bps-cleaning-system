<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('report_photos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('report_id')->constrained('reports')->onDelete('cascade');
            $table->string('photo_path'); // Path to the photo file
            $table->string('original_name')->nullable(); // Original filename
            $table->integer('file_size')->nullable(); // File size in bytes
            $table->string('mime_type')->nullable(); // File MIME type
            $table->integer('order')->default(0); // Order of photos
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('report_photos');
    }
};

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
        Schema::create('reports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('area_id')->constrained('areas')->onDelete('cascade'); // Area yang dilaporkan
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Petugas yang buat laporan
            $table->string('title'); // Judul laporan
            $table->text('description')->nullable(); // Deskripsi laporan
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending'); // Status laporan
            $table->date('submission_date'); // Tanggal pengerjaan
            $table->text('admin_notes')->nullable(); // Catatan dari admin
            $table->foreignId('reviewed_by')->nullable()->constrained('users')->onDelete('set null'); // Admin yang review
            $table->timestamp('reviewed_at')->nullable(); // Kapan di-review
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};

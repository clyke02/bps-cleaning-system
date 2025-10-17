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
        Schema::create('areas', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Nama area
            $table->enum('floor', ['1', '2']); // Lantai 1 atau 2
            $table->string('room_number', 10); // Nomor ruangan
            $table->text('description')->nullable(); // Keterangan
            $table->foreignId('created_by')->nullable()->constrained('users')->onDelete('set null'); // Admin yang membuat
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('areas');
    }
};

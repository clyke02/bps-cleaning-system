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
        Schema::create('daily_assignments', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('area_id');
            $table->date('assignment_date');
            $table->enum('status', ['pending', 'completed', 'missed'])->default('pending');
            $table->unsignedBigInteger('report_id')->nullable(); // Link ke report jika sudah dikerjakan
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('area_id')->references('id')->on('areas')->onDelete('cascade');
            $table->foreign('report_id')->references('id')->on('reports')->onDelete('set null');
            
            // Constraint untuk mencegah duplikasi assignment per hari
            $table->unique(['user_id', 'area_id', 'assignment_date']);
            
            $table->index(['assignment_date', 'status']);
            $table->index(['user_id', 'assignment_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('daily_assignments');
    }
};
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
        Schema::table('report_tasks', function (Blueprint $table) {
            $table->foreignId('cleaning_task_id')->nullable()->after('report_id')->constrained('area_cleaning_tasks')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('report_tasks', function (Blueprint $table) {
            $table->dropForeign(['cleaning_task_id']);
            $table->dropColumn('cleaning_task_id');
        });
    }
};


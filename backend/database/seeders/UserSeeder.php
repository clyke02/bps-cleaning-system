<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        
        // Admin user
        User::create([
            'name' => 'Admin 01',
            'email' => 'admin01@example.com',
            'password' => Hash::make('admin01'),
            'role' => 'admin',
        ]);

        // Regular user
        User::create([
            'name' => 'User 01',
            'email' => 'user01@example.com',
            'password' => Hash::make('user01'),
            'role' => 'user',
        ]);
    }
}

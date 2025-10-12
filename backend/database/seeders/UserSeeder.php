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
        
        // Super Admin user (bootstrap account)
        User::create([
            'name' => 'Super Admin',
            'username' => 'superadmin',
            'password' => Hash::make('superadmin123'),
            'role' => 'admin',
        ]);

        // Sample Admin user
        User::create([
            'name' => 'Bambang Sutrisno',
            'username' => 'bambang.admin',
            'phone' => '081234567890',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        // Sample Petugas user  
        User::create([
            'name' => 'Ahmad Suryadi',
            'username' => 'ahmad.petugas',
            'phone' => '081234567891',
            'password' => Hash::make('petugas123'),
            'role' => 'user',
        ]);
    }
}

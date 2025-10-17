<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FCMService
{
    private const FCM_URL_V1 = 'https://fcm.googleapis.com/v1/projects/%s/messages:send';
    
    /**
     * Send notification to specific user(s)
     */
    public static function sendToUser($fcmToken, string $title, string $body, array $data = [])
    {
        if (empty($fcmToken)) {
            return false;
        }
        
        $tokens = is_array($fcmToken) ? $fcmToken : [$fcmToken];
        $tokens = array_filter($tokens); // Remove null values
        
        if (empty($tokens)) {
            return false;
        }
        
        // Convert all data values to strings (FCM requirement)
        $stringData = [];
        foreach ($data as $key => $value) {
            $stringData[$key] = (string) $value;
        }
        
        $notification = [
            'title' => $title,
            'body' => $body,
        ];
        
        $payload = [
            'registration_ids' => $tokens,
            'notification' => $notification,
            'data' => $stringData,
            'priority' => 'high',
            'android' => [
                'priority' => 'high',
                'notification' => [
                    'sound' => 'default',
                    'default_sound' => true,
                    'default_vibrate_timings' => true,
                    'notification_priority' => 'PRIORITY_HIGH',
                    'visibility' => 'PUBLIC',
                ],
            ],
        ];
        
        return self::send($payload);
    }
    
    /**
     * Send notification to all users with specific role
     */
    public static function sendToRole(string $role, string $title, string $body, array $data = [])
    {
        $users = \App\Models\User::where('role', $role)
            ->whereNotNull('fcm_token')
            ->pluck('fcm_token')
            ->toArray();
        
        if (empty($users)) {
            Log::info("No users found with role: $role");
            return false;
        }
        
        return self::sendToUser($users, $title, $body, $data);
    }
    
    /**
     * Send FCM request
     */
    private static function send(array $payload): bool
    {
        try {
            $projectId = env('FIREBASE_PROJECT_ID');
            $accessToken = self::getAccessToken();

            if (!$projectId || !$accessToken) {
                Log::error('FCM v1 missing configuration (FIREBASE_PROJECT_ID or service account)');
                return false;
            }

            $response = Http::withOptions(['verify' => false])
                ->withHeaders([
                    'Authorization' => 'Bearer ' . $accessToken,
                    'Content-Type' => 'application/json',
                ])->post(sprintf(self::FCM_URL_V1, $projectId), [
                    'message' => [
                        'token' => $payload['registration_ids'][0] ?? null,
                        'notification' => $payload['notification'] ?? null,
                        'data' => $payload['data'] ?? null,
                        'android' => [
                            'priority' => 'HIGH',
                            'notification' => [
                                'sound' => 'default',
                                'default_sound' => true,
                                'default_vibrate_timings' => true,
                                'notification_priority' => 'PRIORITY_HIGH',
                                'visibility' => 'PUBLIC',
                            ],
                        ],
                    ],
                ]);
            
            if ($response->successful()) {
                Log::info('FCM notification sent successfully', ['payload' => $payload]);
                return true;
            }
            
            Log::error('FCM notification failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);
            
            return false;
        } catch (\Exception $e) {
            Log::error('FCM notification error: ' . $e->getMessage());
            return false;
        }
    }

    private static function getAccessToken(): ?string
    {
        try {
            $scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
            $keyFile = env('GOOGLE_APPLICATION_CREDENTIALS');
            if (!$keyFile || !file_exists($keyFile)) {
                Log::error('Service account JSON not found. Set GOOGLE_APPLICATION_CREDENTIALS path in .env');
                return null;
            }
            
            // Create HTTP handler that disables SSL verification for development
            $httpHandler = \Google\Auth\HttpHandler\HttpHandlerFactory::build(
                new \GuzzleHttp\Client(['verify' => false])
            );
            
            $creds = new \Google\Auth\Credentials\ServiceAccountCredentials($scopes, $keyFile);
            $token = $creds->fetchAuthToken($httpHandler);
            return $token['access_token'] ?? null;
        } catch (\Exception $e) {
            Log::error('Failed generating Google access token: ' . $e->getMessage());
            return null;
        }
    }
}


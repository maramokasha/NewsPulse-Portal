<?php
// Health endpoint: reports whether the application and the database are up.
header('Content-Type: application/json');
mysqli_report(MYSQLI_REPORT_OFF);

$conn = @new mysqli(
    getenv('DB_HOST') ?: 'localhost',
    getenv('DB_USER') ?: 'root',
    getenv('DB_PASS') ?: '',
    getenv('DB_NAME') ?: 'news_system'
);

if ($conn->connect_error) {
    http_response_code(503);
    echo json_encode(['status' => 'error', 'database' => 'down']);
    exit;
}

echo json_encode(['status' => 'ok', 'database' => 'up']);

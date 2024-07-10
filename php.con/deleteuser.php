<?php

include('connection.php');

$input = file_get_contents('php://input');
$data = json_decode($input, true);

if (isset($data['id'])) {
    $user_id = $data['id'];

    $stmt = $connection->prepare("DELETE FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);

    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(array("message" => "User Deleted"));
        error_log('User berhasil dihapus');
    } else {
        http_response_code(500);
        echo json_encode(array("message" => "Failed to delete customer: " . $stmt->error));
        error_log('User gagal dihapus: ' . $stmt->error);
    }

    $stmt->close();
} else {
    http_response_code(400);
    echo json_encode(array("message" => "Data tidak ditemukan"));
    error_log('Data tidak ditemukan');
}

$connection->close();
?>

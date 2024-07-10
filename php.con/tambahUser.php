<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

/** add koneksi */
require('connection.php');

$input = file_get_contents('php://input');
$data = json_decode($input, true);

if(isset($data['name'], $data['email'], $data['usertype'], $data['phone'], $data['address'], $data['password'])){
    $username = $data['name'];
    $email = $data['email'];
    $usertype = $data['usertype'];
    $phone = $data['phone'];
    $address = $data['address'];
    $password = password_hash($data['password'], PASSWORD_DEFAULT);
    // Prepare the SQL query
    $stmt = $connection->prepare("INSERT INTO users (name, email, usertype, phone, address, password) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $username, $email, $usertype, $phone, $address, $password);

    if($stmt->execute()){
        echo json_encode(["message" => "User created successfully"]);
    } else {
        echo json_encode(["message" => "Error creating user", "error" => $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["message" => "Incomplete data"]);
}

$connection->close();
?>

<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

/** add koneksi */
require('connection.php');

$input = file_get_contents('php://input');
$data = json_decode($input, true);

if(isset($data['id'], $data['name'], $data['email'], $data['usertype'], $data['phone'], $data['address'], $data['password'])){
    $id = $data['id'];
    $username = $data['name'];
    $email = $data['email'];
    $usertype = $data['usertype'];
    $phone = $data['phone'];
    $address = $data['address'];
    $password = password_hash($data['password'], PASSWORD_DEFAULT); 

    
    $stmt = $connection->prepare("UPDATE users SET name = ?, email = ?, usertype = ?, phone = ?, address = ?, password = ? WHERE id = ?");
    $stmt->bind_param("ssssssi", $username, $email, $usertype, $phone, $address, $password, $id);

    if($stmt->execute()){
        echo json_encode(["message" => "User updated successfully"]);
    } else {
        echo json_encode(["message" => "Error updating user", "error" => $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["message" => "Incomplete data"]);
}

$connection->close();
?>

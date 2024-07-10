<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header ("Content-Type: application/json");

include ("connection.php");
$result = array();
$queryResult = $connection->query("select * from users");
if ($queryResult){
    while ($fetchdata= $queryResult->fetch_assoc()){
        $result[] = $fetchdata;
    }

    if (empty($result)){
        http_response_code(404);
        echo json_encode(["error" => "No customers found"]);
    } else {
        http_response_code (200);
        echo json_encode($result);
    }
} else {
    http_response_code(500);
    echo json_encode(["error" => "Query faild: " . $connection->error]);
}
$connection->close();
?>
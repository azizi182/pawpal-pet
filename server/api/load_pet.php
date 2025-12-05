<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';
    $sqlloaddata = "SELECT * FROM `tbl_pets`";
    $result = $conn->query($sqlloaddata);
    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        $response = array('status' => 'success','data' => $data);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data'=>null);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed');
    sendJsonResponse($response);
    exit();
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
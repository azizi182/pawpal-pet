<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (!isset($_GET['user_id'])) {
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    $userid = $_GET['user_id'];
    include 'dbconnect.php';
    $sqlgetuser = "SELECT *
     FROM tbl_donation WHERE user_id = '$userid'";
    $result = $conn->query($sqlgetuser);
    
    try{
    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        $response = array('status' => 'success', 'data' => $data);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data'=>null);
        sendJsonResponse($response);
    }
}
catch(Exception $e){
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response);
}

}else{
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') { 
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
// check parameter
if (!isset($_POST['user_id']) || !isset($_POST['pet_id'])) {
    echo json_encode(['status' => 'failed', 'message' => 'Missing parameters']);
    exit();
}

    $user_id = $_POST['user_id'];
    $pet_id = $_POST['pet_id'];
    
    $sqldelete = "DELETE FROM tbl_pets WHERE pet_id = '$pet_id' AND user_id = '$user_id'";
    
    
    try{
        if($conn->query($sqldelete) === TRUE){
            $response = array('status' => 'success', 'message' => 'Pet deleted successfully');
            sendJsonResponse($response);
        }
        else{
            $response = array('status' => 'failed', 'message' => 'Pet deletion failed');
            sendJsonResponse($response);
        }
    
}
catch(Exception $e){
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response);
}





function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
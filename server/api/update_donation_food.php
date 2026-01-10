<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}
$userid = $_POST['user_id']; // user donate
$desc = $_POST['desc'];
$petid = $_POST['pet_id'];




try {

        // get pet id owner
        $sqlowner = "SELECT user_id FROM tbl_pets WHERE pet_id = '$petid'";
        $result = $conn->query($sqlowner);
        $row = $result->fetch_assoc();
        $owner_id = $row['user_id'];

        $donation_type = "food/medical";
        // insert into tbl donations
        $sqlinsertdonation = "INSERT INTO `tbl_donation`(`donation_type`, `donation_amount`, `user_id`, `pet_id`, `owner_id`) 
        VALUES ('$donation_type', '$desc', '$userid', '$petid', '$owner_id')";

        if ($conn->query($sqlinsertdonation) === TRUE) {
            sendJsonResponse([
                'status' => 'success',
                'message' => 'Donation updated successfully'
            ]);
        } else {
            sendJsonResponse([
                'status' => 'failed',
                'message' => 'Failed to update donation'
            ]);
        }
    
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}


function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}

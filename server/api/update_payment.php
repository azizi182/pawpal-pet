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
$amount = $_POST['amount'];
$petid = $_POST['pet_id'] ?? null; // user receive donation
$mode = $_POST['mode']; 



try {

   

    if($mode == "topup"){
        // Add to user's wallet
        $sqlupdatetopup = "UPDATE tbl_users SET user_wallet = user_wallet + '$amount' WHERE user_id = '$userid'";
    

    if ($conn->query($sqlupdatetopup) === TRUE) {
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Wallet top up updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Failed to top up wallet'
        ]);
    }
} else if($mode == "donate"){

        // get pet id owner
        $sqlowner = "SELECT user_id FROM tbl_pets WHERE pet_id = '$petid'";
        $result = $conn->query($sqlowner);
        $row = $result->fetch_assoc();
        $owner_id = $row['user_id'];

        // Deduct from user wallet
        $sqlupdatedonate = "UPDATE tbl_users SET user_wallet = user_wallet - '$amount' WHERE user_id = '$userid'";
        $conn->query($sqlupdatedonate);

        

        // Add to owner donation total
        $sqlupdatepetdonation = "UPDATE tbl_users SET user_wallet = user_wallet + '$amount' WHERE user_id = '$owner_id'";
        $conn->query($sqlupdatepetdonation);

        $donation_type = "money";
        // insert into tbl donations
        $sqlinsertdonation = "INSERT INTO `tbl_donation`(`donation_type`, `donation_amount`, `user_id`, `pet_id`, `owner_id`) 
        VALUES ('$donation_type', '$amount', '$userid', '$petid', '$owner_id')";

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
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Invalid mode'
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

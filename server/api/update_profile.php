<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}
$userid    = $_POST['user_id'];
$name      = addslashes($_POST['user_name']);
$phone     = addslashes($_POST['user_phone']);
$email     = addslashes($_POST['user_email']);


try {
    $sqlupdateuser = "UPDATE tbl_users SET 
    user_name = '$name', user_phone = '$phone', 
    user_email = '$email'
    WHERE user_id = '$userid'";

    if ($conn->query($sqlupdateuser) === TRUE) {
        //image part
        if (!empty($_POST['image'])) {

            $base64Image = $_POST['image'];

            //Remove base64 header if exists
            if (strpos($base64Image, ',') !== false) {
                $base64Image = explode(',', $base64Image)[1];
            }

            $decodedImage = base64_decode($base64Image);

            if ($decodedImage === false) {
                throw new Exception("Invalid image data");
            }

            //File image
            $fileName = "profile_" . $userid . ".png";
            $filePath = "../image_profile/" . $fileName;

            file_put_contents($filePath, $decodedImage);

            
            $conn->query("UPDATE tbl_users SET user_picture = '$fileName' WHERE user_id = '$userid'");
        }
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Profile updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Profile update failed'
        ]);
    }
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

// ---------- JSON response ----------
function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}

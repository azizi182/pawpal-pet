<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}
$adopt_id    = $_POST['adopt_id'];
$action      = $_POST['action'];


try {
    $sqlupdateadopt = "UPDATE tbl_adoption
    SET status = '$action'
    WHERE adopt_id = '$adopt_id'";

    if ($conn->query($sqlupdateadopt) === TRUE) {
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Adoption updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Adoption update failed'
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

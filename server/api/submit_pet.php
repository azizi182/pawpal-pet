<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

$user_id = $_POST['user_id'];
$pet_name = $_POST['pet_name'];
$pet_type = $_POST['pet_type'];
$category = $_POST['pet_category'];
$description = addslashes($_POST['description']);
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];

$sqlinsertpet = "INSERT INTO tbl_pets (user_id, pet_name, pet_type, category, description, image_paths, lat, lng)
VALUES ('$user_id', '$pet_name', '$pet_type', '$category', '$description', '', '$latitude', '$longitude')";


if ($conn->query($sqlinsertpet) === TRUE) {

    $last_id = $conn->insert_id;
	//get base64 images type from flutter and save them
    $images = json_decode($_POST['image'], true);
    $image_paths = [];

    if (is_array($images)) {
    for ($i = 0; $i < count($images); $i++) {

        // decode/convert string to image
        $decodedImage = base64_decode($images[$i]);
        // file name: pet_5_1.png, pet_5_2.png, pet_5_3.png
        $fileName = "pet_" . $last_id . "_" . ($i + 1) . ".png";
        // server storage path
        $filePath = "../file_put_contents/" . $fileName;
        // save image file to server
        file_put_contents($filePath, $decodedImage);
        // store file name in array
        $image_paths[] = $fileName;
    }
}
// convert path file to json and update database
    $image_paths_json = json_encode($image_paths);
    $conn->query("UPDATE tbl_pets SET image_paths = '$image_paths_json' WHERE pet_id = $last_id");
    sendJsonResponse(['status' => 'success', 'message' => 'Successfully added']);
} else {
    sendJsonResponse(['status' => 'failed', 'message' => 'Failed to add']);
}

function sendJsonResponse($array)
{
    header('Content-Type: application/json');
    echo json_encode($array);
}

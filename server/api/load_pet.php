<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';

    $basesql = "SELECT * FROM `tbl_pets`";

    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);

        $sqlloaddata = $basesql . "
            WHERE 
                pet_name LIKE '%$search%' 
                OR pet_type LIKE '%$search%'
                OR pet_health LIKE '%$search%'
                OR category LIKE '%$search%'
            ORDER BY pet_id DESC";
    } else {
        $sqlloaddata = $basesql . " ORDER BY pet_id DESC";
    }

    
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
    <?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'GET') {
        if (!isset($_GET['owner_id'])) {
            $response = array('status' => 'failed', 'message' => 'Bad Request');
            sendJsonResponse($response);
            exit();
        }
    }
    $owner_id = $_GET['owner_id'];

    //table pet for details of pet
    //table adoption details of adoption
    // page owner
    try {
        $sqlgetadopt = "SELECT 
    a.adopt_id,
    a.pet_id,
    a.owner_id,
    a.user_id,
    a.msg AS adopt_msg,
    a.status AS adopt_status,

    p.pet_name,
    p.pet_type,
    p.pet_age,
    p.pet_gender,
    p.pet_health,
    p.category,
    p.image_paths,

    u.user_name AS adopt_name
    
    FROM tbl_adoption a
    JOIN tbl_pets p ON a.pet_id = p.pet_id
    JOIN tbl_users u ON a.user_id = u.user_id
    WHERE a.owner_id = '$owner_id' AND a.status = 'Pending'
    ORDER BY a.adopt_id DESC";

        $result = $conn->query($sqlgetadopt);
        if ($result->num_rows > 0) {
            $dataadopt = array();
            while ($row = $result->fetch_assoc()) {
                $dataadopt[] = $row;
            }

            $response = array('status' => 'success', 'message' => 'Success', 'data' => $dataadopt);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'message' => 'Invalid request', 'data' => null);
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        sendJsonResponse(['status' => 'failed', 'message' => $e->getMessage()]);
    }
    function sendJsonResponse($array)
    {
        header('Content-Type: application/json');
        echo json_encode($array);
    }

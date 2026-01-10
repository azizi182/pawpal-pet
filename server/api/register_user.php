
<?php
    header('Access-Control-Allow-Origin: *'); //for web to avoid crash
    include 'dbconnect.php'; // must have to connect database

    // for security
    if($_SERVER['REQUEST_METHOD'] != 'POST'){
        echo "Only POST method is allowed";
        exit();
    }

    if(!isset($_POST['email']) || !isset($_POST['password'])){
        echo "Email or password is not set";
        exit();
    }

    $email = $_POST['email'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $password = $_POST['password'];
    $hashed_password = sha1($password); // change to hashed password for security
    $user_picture = null;
    $user_wallet = 0;
    

    // Check if email already exists
    $sqlCheck = "SELECT * FROM `tbl_users` WHERE user_email = '$email'";
    $result = $conn->query($sqlCheck);

    if ($result->num_rows > 0) {
        $response = array("status" => "duplicate", "message" => "Email already registered");
        sendJsonResponse($response);
        exit();
    }
    
    // sql to insert data
    $sqlreg = $sqlreg = "INSERT INTO `tbl_users` (`user_name`, `user_email`, `user_password`, `user_phone`, `user_picture`, `user_wallet`)
    VALUES ('$name', '$email', '$hashed_password', '$phone' , '$user_picture', '$user_wallet')";

    try{
    //to popup message
        if($conn->query($sqlreg) === TRUE){ 
            $response = array("status" => "success", "message" => "User registered successfully");
            sendJsonResponse($response);
        } else {
            $response = array("status" => "failed", "message" => "User registered failed");
            sendJsonResponse($response);
        }
    } catch(Exception $e){
        $response = array("status" => "error", "message" => "Error with database");
        sendJsonResponse($response);
    }

    function sendJsonResponse($response){
        header('Content-Type: application/json');
        echo json_encode($response);
    }
    
?>

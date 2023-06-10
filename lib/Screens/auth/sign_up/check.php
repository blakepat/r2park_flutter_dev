<?php
    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    $email = $_POST['email'];

    $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");
    $count = mysqli_num_rows($select);
    $data = mysqli_fetch_assoc($select);

    $idData = $data['user_id'];
    $userData = $data['email'];

    if($count != 0) {

        $url = 'http://'.$_SERVER['SERVER_NAME'].'/changepass.php?user_id='.$idData.'&email='.$userData;
        
        echo json_encode($url);
    } else {
        
        echo json_encode("INVALIDUSER");
    }
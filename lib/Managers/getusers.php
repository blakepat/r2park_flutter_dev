<?php
    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    $select = $db->query("SELECT * FROM users");

    $count = mysqli_num_rows($select);
    $data = mysqli_fetch_assoc($select);

    if($count != 0) {
        echo json_encode('success '".$count."'');
    } else {
        echo json_encode('ERROR GETTING USERS');
    } 
?>
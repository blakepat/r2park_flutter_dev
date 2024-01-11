<?php

//*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    // echo json_encode('2');

    $email = $_POST['email'];


    $query = "SELECT * FROM users WHERE email = '".$email."'";
    $result = mysqli_query($db, $query);
    // $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");

    $count = mysqli_num_rows($result);

    if ($count != 0) {
        $update = $db->query("DELETE FROM users WHERE email = '".$email."' ");
        if ($update) {
            echo json_encode('SUCCESS');   
        }  else {
            echo json_encode('FAILURE');
        }
    } else {
        echo json_encode('COUNT3');
    }
?>
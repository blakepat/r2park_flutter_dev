<?php

    //*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    // echo json_encode("COUNT1");
    // $user_id = $_GET['user_id'];
    
    $email = $_POST['email'];
    $newPassword = $_POST['newPassword'];

    // http://192.168.68.102/changepass.php?user_id=555&email=blakepat@me.com
    // $user_id = '555';
    // $email = 'blakepat@me.com';

    // $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");
    // $count = mysqli_num_rows($select);
    // $data = mysqli_fetch_assoc($select);

    // $idData = $data['user_id'];

    $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");
    // $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");
    $count = mysqli_num_rows($select);
    // $count = 1;

    // echo json_encode("COUNT2");


    if ($count != 0) {
        $update = $db->query("UPDATE users SET password = '".$newPassword."' WHERE email = '".$email."' ");
        // $update = $db->query("UPDATE users SET password = '".$newPass."' WHERE email = '".$email."' ");
        
        if ($update) {
            echo json_encode('SUCCESS!!!');   
        }  else {
            echo json_encode('FAILURE!!!');
        }
    } else {
        echo json_encode('COUNT3');
    }
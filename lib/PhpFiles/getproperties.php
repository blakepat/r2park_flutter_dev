<?php

//*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    // $db = mysqli_connect("10.0.2.2", "root", "", "parkinm2_r2p-flutter-dev3", 3306); //FOR ANDROID
    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    $query = "SELECT * FROM properties";
    $result = mysqli_query($db, $query);

    $count = mysqli_num_rows($result);

    $rows = array();
    while($row = $result->fetch_assoc()) {
        array_push($rows, $row);
    }

    

    if($count != 0) {
        // echo json_encode('success '".$count."'');
        echo json_encode($rows);
    } else {
        echo json_encode('ERROR GETTING USERS');
    } 
?>
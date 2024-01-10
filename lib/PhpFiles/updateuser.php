<?php

//*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    // echo json_encode('2');

    $email = $_POST['email'];
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $mobileNumber = $_POST['mobileNumber'];
    $apartmentNumber = $_POST['apartmentNumber'];
    $address = $_POST['address'];
    $city = $_POST['city'];
    $province = $_POST['province'];
    $postalCode = $_POST['postalCode'];
    $companyAddress = $_POST['companyAddress'];
    // $companyCity = $_POST['companyCity'];
    $password = $_POST['password'];


    $query = "SELECT * FROM users WHERE email = '".$email."'";
    $result = mysqli_query($db, $query);
    // $select = $db->query("SELECT * FROM users WHERE email = '".$email."'");

    $count = mysqli_num_rows($result);

    if ($count != 0) {
        $update = $db->query("UPDATE users SET name = '$firstName', last_name = '$lastName', mobileNumber = '$mobile',  address1 = '$address', address2 = '$apartmentNumber', city = '$city', province = '$province', postal_code = '$postalCode', companyAddress = '$companyAddress', password = '$password' WHERE email = '".$email."' ");
        if ($update) {
            echo json_encode('SUCCESS');   
        }  else {
            echo json_encode('FAILURE');
        }
    } else {
        echo json_encode('COUNT3');
    }
?>
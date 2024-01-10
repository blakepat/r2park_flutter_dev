<?php

    //*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }

    $Reg_Date = $_POST['Reg_Date'];
    $fk_Plate_ID = $_POST['fk_Plate_ID'];
    $fk_property_id = $_POST['fk_property_id'];
    $Start_Date = $_POST['Start_Date'];
    $End_Date = $_POST['End_Date'];
    $Unit_No = $_POST['Unit_No'];
    $Street_Name = $_POST['Street_Name'];
    $fk_Zone_ID = $_POST['fk_Zone_ID'];
    $email = $_POST['email'];
    $Phone = $_POST['Phone'];
    $Name = $_POST['Name'];
    $Make_Model = $_POST['Make_Model'];
    $Days = $_POST['Days'];
    $Reason = $_POST['Reason'];
    $Notes = $_POST['Notes'];
    $Auth_By = $_POST['Auth_By'];
    $IsArchived = $_POST['IsArchived'];
    $street_number = $_POST['street_number'];
    $street_suffix = $_POST['street_suffix'];
    $address = $_POST['address'];


    $update = $db->query("INSERT INTO pp_self_reg (Reg_Date, fk_Plate_ID, fk_property_id, Start_Date, End_Date, Unit_No, Street_Name, fk_Zone_ID, email, Phone, Name, Make_Model, Days, Reason, Notes, Auth_By, IsArchived, street_number, street_suffix, address) VALUES ('$Reg_Date', '$fk_Plate_ID', '$fk_property_id', '$Start_Date', '$End_Date', '$Unit_No', '$Street_Name', '$fk_Zone_ID', '$email', '$Phone', '$Name', '$Make_Model', '$Days', '$Reason', '$Notes', '$Auth_By', '$IsArchived', '$street_number', '$street_suffix', '$address')");
   
    if ($update) {
        echo json_encode('SUCCESS CREATING CREATING EXEMPTION');   
    }  else {
        echo json_encode('FAILURE CREATING CREATING EXEMPTION');
    }

?>
<?php

    //*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    if(!$db) {
        echo "Database connect error".mysqli_error();
    }


    $prefix = $_POST['prefix'];
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $email = $_POST['email'];
    $mobileNumber = $_POST['mobileNumber'];
    $plateNumber = $_POST['plateNumber'];
    $state = $_POST['state'];
    $address1 = $_POST['address1'];
    $address2 = $_POST['address2'];
    $city = $_POST['city'];
    $province = $_POST['province'];
    $postalCode = $_POST['postalCode'];
    $password = $_POST['password'];
    $status = (int) $_POST['status'];
    $created = $_POST['created'];
    $initials = $_POST['initials'];
    $clientDisplayName = $_POST['clientDisplayName'];
    $authorityLevel = (int) $_POST['authorityLevel'];
    $role = $_POST['role'];
    $otp = (int) $_POST['otp'];
    $enrollServices = (int) $_POST['enrollServices'];
    $companyName = $_POST['companyName'];
    $companyAddress = $_POST['companyAddress'];
    $comments = $_POST['comments'];
    $accessCode = $_POST['accessCode'];
    $fax = $_POST['fax'];
    $notes = $_POST['notes'];
    $clientId = $_POST['clientId'];
    $employeeId = (int) $_POST['employeeId'];
    $enforceID = (int) $_POST['enforceID'];
    $workLocation = $_POST['workLocation'];
    $gender = $_POST['gender'];
    $joiningDate = $_POST['joiningDate'];
    $dateOfBirth = $_POST['dateOfBirth'];
    $address = $_POST['address'];
    $salary = (int) $_POST['salary'];
    $propertyType = $_POST['propertyType'];
    $property = $_POST['property'];
    $jobType = $_POST['jobType'];
    $about = $_POST['about'];
    $paymentOptions = $_POST['paymentOptions'];
    $accessProperties = $_POST['accessProperties'];
    $accessedByClient = (int) $_POST['accessedByClient'];
    $isContact = (int) $_POST['isContact'];
    $accessedByProperty = (int) $_POST['accessedByProperty'];
    $allowDashboard = (int) $_POST['allowDashboard'];
    $title = $_POST['title'];
    $position = $_POST['position'];
    $visibleAccess = (int) $_POST['visibleAccess'];
    $country = $_POST['country'];
    $area = $_POST['area'];
    $zone = $_POST['zone'];
    $userId = $_POST['userId'];
    $propertyTypes = $_POST['propertyTypes'];
    $condoNumber = $_POST['condoNumber'];
    $condoName = $_POST['condoName'];
    $condoAddress = $_POST['condoAddress'];
    $loginId = $_POST['loginId'];
    $memberSince = $_POST['memberSince'];
    $homePhone = $_POST['homePhone'];
    $businessPhone = $_POST['businessPhone'];
    $email2 = $_POST['email2'];
    $mailingAddress = $_POST['mailingAddress'];
    $signature = $_POST['signature'];
    $employeeRole = (int) $_POST['employeeRole'];
    $mleoId = $_POST['mleoId'];
    $defaultShow = (int) $_POST['defaultShow'];
    $signVendorId = (int) $_POST['signVendorId'];
    $multiZone = $_POST['multiZone'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $holidayRate = $_POST['holidayRate'];


    $resultOfQuery = $db->query($sqlQuery);

    if($resultOfQuery) {
        echo json_encode('SUCCESS');
    } else {
        echo json_encode('FAILURE');
    }

    // $query = "SELECT * FROM users WHERE email = '".$email."'";
    // $result = mysqli_query($db, $query);
    // $count = mysqli_num_rows($result);


    // if ($count == 0) { 
    //     $update = $db->query("INSERT INTO users (prefix, name, last_name, email, mobile, plateNumber, state, address1, address2, city, province, postal_code, password, status, created, initials, client_display_name, auth_level, role, otp, enrollServices, companyName, companyAddress, comments, accessCode, fax, notes, clientID, employeeId, enforceId, work_location, gender, joining_date, date_of_birth, address, salary, property_type, property, job_type, about, payment_options, access_properties, accessed_by_client, is_contact, accessed_by_property, allow_dashboard, title, position, visible_access, country, area, zone, userId, property_types, condo_number, condo_name, condo_addr, login_id, member_since, home_phone, business_phone, email2, mailing_address, signature, employee_role, mleo_id, default_show, signvendorId, multi_zone, latitude, longitude, holiday_rate) VALUES('$prefix', '$firstName', '$lastName', '$email', '$mobileNumber', '$plateNumber', '$state', '$address1', '$address2', '$city', '$province', '$postalCode', '$password', '$status', '$created', '$initials', '$clientDisplayName', '$authorityLevel', '$role', '$otp', '$enrollServices', '$companyName' ,'$companyAddress' ,'$comments' ,'$accessCode' ,'$fax' ,'$notes' ,'$clientId' ,'$employeeId' ,'$enforceID' ,'$workLocation' ,'$gender' ,'$joiningDate' ,'$dateOfBirth' ,'$address' ,'$salary' ,'$propertyType' ,'$property' ,'$jobType' ,'$about' ,'$paymentOptions' ,'$accessProperties' ,'$accessedByClient' ,'$isContact' ,'$accessedByProperty' ,'$allowDashboard' ,'$title' ,'$position' ,'$visibleAccess' ,'$country' ,'$area' ,'$zone' ,'$userId' ,'$propertyTypes' ,'$condoNumber' ,'$condoName' ,'$condoAddress' ,'$loginId' ,'$memberSince' ,'$homePhone' ,'$businessPhone' ,'$email2' ,'$mailingAddress' ,'$signature' ,'$employeeRole' ,'$mleoId' ,'$defaultShow' ,'$signVendorId', '$multiZone', '$latitude', '$longitude', '$holidayRate')");
    //     // $update = $db->query("UPDATE users SET name = '$firstName', last_name = '$lastName', mobileNumber = '$mobile',  address1 = '$address', address2 = '$apartmentNumber', city = '$city', province = '$province', postal_code = '$postalCode', companyAddress = '$companyAddress', password = '$password' WHERE email = '".$email."' ");
    //     if ($update) {
    //         echo json_encode('SUCCESS');   
    //     }  else {
    //         echo json_encode('FAILURE');
    //     }
    // } else {
    //     echo json_encode('COUNT3');
    // }


    // $query = "SELECT * FROM users WHERE email = '".$email."'";
    // $result = mysqli_query($db, $query);
    // $count = mysqli_num_rows($result);


    // if ($count == 0) { 
    //     $update = $db->query("INSERT INTO users (prefix, name, last_name, email, mobile, plateNumber, state, address1, address2, city, province, postal_code, password, status, created, initials, client_display_name, auth_level, role, otp, enrollServices, companyName, companyAddress, comments, accessCode, fax, notes, clientID, employeeId, enforceId, work_location, gender, joining_date, date_of_birth, address, salary, property_type, property, job_type, about, payment_options, access_properties, accessed_by_client, is_contact, accessed_by_property, allow_dashboard, title, position, visible_access, country, area, zone, userId, property_types, condo_number, condo_name, condo_addr, login_id, member_since, home_phone, business_phone, email2, mailing_address, signature, employee_role, mleo_id, default_show, signvendorId, multi_zone, latitude, longitude, holiday_rate) VALUES('$prefix', '$firstName', '$lastName', '$email', '$mobileNumber', '$plateNumber', '$state', '$address1', '$address2', '$city', '$province', '$postalCode', '$password', '$status', '$created', '$initials', '$clientDisplayName', '$authorityLevel', '$role', '$otp', '$enrollServices', '$companyName' ,'$companyAddress' ,'$comments' ,'$accessCode' ,'$fax' ,'$notes' ,'$clientId' ,'$employeeId' ,'$enforceID' ,'$workLocation' ,'$gender' ,'$joiningDate' ,'$dateOfBirth' ,'$address' ,'$salary' ,'$propertyType' ,'$property' ,'$jobType' ,'$about' ,'$paymentOptions' ,'$accessProperties' ,'$accessedByClient' ,'$isContact' ,'$accessedByProperty' ,'$allowDashboard' ,'$title' ,'$position' ,'$visibleAccess' ,'$country' ,'$area' ,'$zone' ,'$userId' ,'$propertyTypes' ,'$condoNumber' ,'$condoName' ,'$condoAddress' ,'$loginId' ,'$memberSince' ,'$homePhone' ,'$businessPhone' ,'$email2' ,'$mailingAddress' ,'$signature' ,'$employeeRole' ,'$mleoId' ,'$defaultShow' ,'$signVendorId', '$multiZone', '$latitude', '$longitude', '$holidayRate')");
    //     // $update = $db->query("UPDATE users SET name = '$firstName', last_name = '$lastName', mobileNumber = '$mobile',  address1 = '$address', address2 = '$apartmentNumber', city = '$city', province = '$province', postal_code = '$postalCode', companyAddress = '$companyAddress', password = '$password' WHERE email = '".$email."' ");
    //     if ($update) {
    //         echo json_encode('SUCCESS');   
    //     }  else {
    //         echo json_encode('FAILURE');
    //     }
    // } else {
    //     echo json_encode('COUNT3');
    // }


    // //*COPY THIS FILE TO YOUR XAMPP/HTDOCS FOLDER */

    // $db = mysqli_connect("localhost", "root", "", "parkinm2_r2p-flutter-dev3", 3306);
    // if(!$db) {
    //     echo "Database connect error".mysqli_error();
    // }

    // // $user = $POST'user');
    // // $jsondata = file_get_contents('insert.json');
    // // $POST = $json_decode(file_get_contents('php://input'), true);

    // $prefix = $POST['prefix'];
    // $firstName = $POST['firstName'];
    // $lastName = $POST['lastName'];
    // $email = $POST['email'];
    // $mobileNumber = $POST['mobileNumber'];
    // $plateNumber = $POST['plateNumber'];
    // $state = $POST['state'];
    // $address1 = $POST['address1'];
    // $address2 = $POST['address2'];
    // $city = $POST['city'];
    // $province = $POST['province'];
    // $postalCode = $POST['postalCode'];
    // $password = $POST['password'];
    // $status = (int) $POST['status'];
    // $created = $POST['created'];
    // $initials = $POST['initials'];
    // $clientDisplayName = $POST['clientDisplayName'];
    // $authorityLevel = (int) $POST['authorityLevel'];
    // $role = $POST['role'];
    // $otp = (int) $POST['otp'];
    // $enrollServices = (int) $POST['enrollServices'];
    // $companyName = $POST['companyName'];
    // $companyAddress = $POST['companyAddress'];
    // $comments = $POST['comments'];
    // $accessCode = $POST['accessCode'];
    // $fax = $POST['fax'];
    // $notes = $POST['notes'];
    // $clientId = $POST['clientId'];
    // $employeeId = (int) $POST['employeeId'];
    // $enforceID = (int) $POST['enforceID'];
    // $workLocation = $POST['workLocation'];
    // $gender = $POST['gender'];
    // $joiningDate = $POST['joiningDate'];
    // $dateOfBirth = $POST['dateOfBirth'];
    // $address = $POST['address'];
    // $salary = (int) $POST['salary'];
    // $propertyType = $POST['propertyType'];
    // $property = $POST['property'];
    // $jobType = $POST['jobType'];
    // $about = $POST['about'];
    // $paymentOptions = $POST['paymentOptions'];
    // $accessProperties = $POST['accessProperties'];
    // $accessedByClient = (int) $POST['accessedByClient'];
    // $isContact = (int) $POST['isContact'];
    // $accessedByProperty = (int) $POST['accessedByProperty'];
    // $allowDashboard = (int) $POST['allowDashboard'];
    // $title = $POST['title'];
    // $position = $POST['position'];
    // $visibleAccess = (int) $POST['visibleAccess'];
    // $country = $POST['country'];
    // $area = $POST['area'];
    // $zone = $POST['zone'];
    // $userId = $POST['userId'];
    // $propertyTypes = $POST['propertyTypes'];
    // $condoNumber = $POST['condoNumber'];
    // $condoName = $POST['condoName'];
    // $condoAddress = $POST['condoAddress'];
    // $loginId = $POST['loginId'];
    // $memberSince = $POST['memberSince'];
    // $homePhone = $POST['homePhone'];
    // $businessPhone = $POST['businessPhone'];
    // $email2 = $POST['email2'];
    // $mailingAddress = $POST['mailingAddress'];
    // $signature = $POST['signature'];
    // $employeeRole = (int) $POST['employeeRole'];
    // $mleoId = $POST['mleoId'];
    // $defaultShow = (int) $POST['defaultShow'];
    // $signVendorId = (int) $POST['signVendorId'];
    // $multiZone = $POST['multiZone'];
    // $latitude = $POST['latitude'];
    // $longitude = $POST['longitude'];
    // $holidayRate = $POST['holidayRate'];


    // $query = "SELECT * FROM users WHERE email = '".$email."'";
    // $result = mysqli_query($db, $query);
    // $count = mysqli_num_rows($result);


    // if ($count == 0) { 
    //     $update = $db->query("INSERT INTO users (prefix, name, last_name, email, mobile, plateNumber, state, address1, address2, city, province, postal_code, password, status, created, initials, client_display_name, auth_level, role, otp, enrollServices, companyName, companyAddress, comments, accessCode, fax, notes, clientID, employeeId, enforceId, work_location, gender, joining_date, date_of_birth, address, salary, property_type, property, job_type, about, payment_options, access_properties, accessed_by_client, is_contact, accessed_by_property, allow_dashboard, title, position, visible_access, country, area, zone, userId, property_types, condo_number, condo_name, condo_addr, login_id, member_since, home_phone, business_phone, email2, mailing_address, signature, employee_role, mleo_id, default_show, signvendorId, multi_zone, latitude, longitude, holiday_rate) VALUES('$prefix', '$firstName', '$lastName', '$email', '$mobileNumber', '$plateNumber', '$state', '$address1', '$address2', '$city', '$province', '$postalCode', '$password', '$status', '$created', '$initials', '$clientDisplayName', '$authorityLevel', '$role', '$otp', '$enrollServices', '$companyName' ,'$companyAddress' ,'$comments' ,'$accessCode' ,'$fax' ,'$notes' ,'$clientId' ,'$employeeId' ,'$enforceID' ,'$workLocation' ,'$gender' ,'$joiningDate' ,'$dateOfBirth' ,'$address' ,'$salary' ,'$propertyType' ,'$property' ,'$jobType' ,'$about' ,'$paymentOptions' ,'$accessProperties' ,'$accessedByClient' ,'$isContact' ,'$accessedByProperty' ,'$allowDashboard' ,'$title' ,'$position' ,'$visibleAccess' ,'$country' ,'$area' ,'$zone' ,'$userId' ,'$propertyTypes' ,'$condoNumber' ,'$condoName' ,'$condoAddress' ,'$loginId' ,'$memberSince' ,'$homePhone' ,'$businessPhone' ,'$email2' ,'$mailingAddress' ,'$signature' ,'$employeeRole' ,'$mleoId' ,'$defaultShow' ,'$signVendorId', '$multiZone', '$latitude', '$longitude', '$holidayRate')");
    //     // $update = $db->query("UPDATE users SET name = '$firstName', last_name = '$lastName', mobileNumber = '$mobile',  address1 = '$address', address2 = '$apartmentNumber', city = '$city', province = '$province', postal_code = '$postalCode', companyAddress = '$companyAddress', password = '$password' WHERE email = '".$email."' ");
    //     if ($update) {
    //         echo json_encode('SUCCESS');   
    //     }  else {
    //         echo json_encode('FAILURE');
    //     }
    // } else {
    //     echo json_encode('COUNT3');
    // }
?>
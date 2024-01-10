// import '../models/user.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class UserManager {
//   // var db = Mysql();

//   Future<List<User>> getUsers() async {
//     //FOR ANDROID SIMULATOR **********
//     // var url = Uri.parse('http://10.0.2.2/getusers.php');
//     //FOR iOS SIMULATOR AND WEB **********
//     var url = Uri.parse('http://localhost/getusers.php');

//     var response = await http.get(url);

//     var users = json.decode(response.body);
//     final List databaseUsersList = json.decode(response.body);

//     List<User> usersList =
//         databaseUsersList.map((val) => User.convertFromJson(val)).toList();

//     if (users == "ERROR GETTING USERS") {
//       print('❌❌');
//       return [];
//     } else {
//       // print('✅✅');
//       return usersList;
//     }
//   }

//   // Future<void> createNewUser(User user) async {
//   //   // var url = Uri.parse('http://10.0.2.2/insertuser.php');
//   //   var url = Uri.parse('http://localhost/insertuser.php');
//   //   var response = await http.post(url, body: user.toJson()
//         // var url = Uri.parse('http://localhost/insertuser.php');
//         // // print(user.created.toString().split(".")[0]);
//         // // debugPrint(user.toJson2().toString());
//         // var client = new http.Client();
//         // var response = await client
//         //     .post(
//         //   Uri.parse('http://localhost/insertuser.php'),
//         // headers: {
//         // 'Content-Type': 'application/json',
//         // 'Content-Type': 'application/x-www-form-urlencoded',
//         // },
//         // body: user.toJson2()
//         // jsonEncode({

//         //   // 'user': user.toJson()

//         //   // 'prefix': user.prefix,
//         //   // 'firstName': user.firstName,
//         //   // 'lastName': user.lastName,
//         //   // 'email': user.email,
//         //   // 'mobileNumber': user.mobileNumber,
//         //   // 'plateNumber': user.plateNumber ?? '',
//         //   // 'state': user.state ?? '',
//         //   // 'address1': user.address1,
//         //   // 'address2': user.address2,
//         //   // 'city': user.city,
//         //   // 'province': user.province,
//         //   // 'postalCode': user.postalCode,
//         //   // 'password': user.password,
//         //   // 'status': user.status,
//         //   // 'created': user.created.toString().split(".")[0],
//         //   // 'initials': user.initials,
//         //   // 'clientDisplayName': user.clientDisplayName,
//         //   // 'authorityLevel': user.authorityLevel,
//         //   // 'role': user.role,
//         //   // 'otp': user.otp,
//         //   // 'enrollServices': user.enrollServices,
//         //   // 'companyName': user.companyName,
//         //   // 'companyAddress': user.companyAddress,
//         //   // 'comments': user.comments,
//         //   // 'accessCode': user.accessCode,
//         //   // 'fax': user.fax,
//         //   // 'notes': user.notes,
//         //   // 'clientId': user.clientId,
//         //   // 'employeeId': user.employeeId,
//         //   // 'enforceID': user.enforceID,
//         //   // 'workLocation': user.workLocation,
//         //   // 'gender': user.gender,
//         //   // 'joiningDate': user.joiningDate.toString().split(".")[0],
//         //   // 'dateOfBirth': user.dateOfBirth.toString().split(".")[0],
//         //   // 'address': user.address,
//         //   // 'salary': user.salary,
//         //   // 'propertyType': user.propertyType,
//         //   // 'property': user.property,
//         //   // 'jobType': user.jobType,
//         //   // 'about': user.about,
//         //   // 'paymentOptions': user.paymentOptions,
//         //   // 'accessProperties': user.accessProperties,
//         //   // 'accessedByClient': user.accessedByClient,
//         //   // 'isContact': user.isContact,
//         //   // 'accessedByProperty': user.accessedByProperty,
//         //   // 'allowDashboard': user.allowDashboard,
//         //   // 'title': user.title,
//         //   // 'position': user.position,
//         //   // 'visibleAccess': user.visibleAccess,
//         //   // 'country': user.country,
//         //   // 'area': user.area,
//         //   // 'zone': user.zone,
//         //   // 'userId': user.userId,
//         //   // 'propertyTypes': user.propertyTypes,
//         //   // 'condoNumber': user.condoNumber,
//         //   // 'condoName': user.condoName,
//         //   // 'condoAddress': user.condoAddress,
//         //   // 'loginId': user.loginId,
//         //   // 'memberSince': user.memberSince.toString().split(".")[0],
//         //   // 'homePhone': user.homePhone,
//         //   // 'businessPhone': user.businessPhone,
//         //   // 'email2': user.email2,
//         //   // 'mailingAddress': user.mailingAddress,
//         //   // 'signature': user.signature,
//         //   // 'employeeRole': user.employeeRole,
//         //   // 'mleoId': user.mleoId,
//         //   // 'defaultShow': user.defaultShow,
//         //   // 'signVendorId': user.signVendorId,
//         //   // 'multiZone': user.multiZone,
//         //   // 'latitude': user.latitude,
//         //   // 'longitude': user.longitude,
//         //   // 'holidayRate': user.holidayRate
//         // })
//         );
//     //     .then((response) {
//     //   client.close();
//     //   if (response.statusCode == 200) {
//     //     print("CODE == 200!!!");
//     //   }
//     // }).catchError((onError) {
//     //   client.close();
//     //   print("Error: $onError");
//     // });

//     // var response = await http.post(url, body: {
//     //   'prefix': user.prefix,
//     //   'firstName': user.firstName,
//     //   'lastName': user.lastName,
//     //   'email': user.email,
//     //   'mobileNumber': user.mobileNumber,
//     //   'plateNumber': user.plateNumber ?? '',
//     //   'state': user.state ?? '',
//     //   'address1': user.address1,
//     //   'address2': user.address2,
//     //   'city': user.city,
//     //   'province': user.province,
//     //   'postalCode': user.postalCode,
//     //   'password': user.password,
//     //   'status': user.status,
//     //   'created': user.created.toString(),
//     //   'initials': user.initials,
//     //   'clientDisplayName': user.clientDisplayName,
//     //   'authorityLevel': user.authorityLevel,
//     //   'role': user.role,
//     //   'otp': user.otp,
//     //   'enrollServices': user.enrollServices,
//     //   'companyName': user.companyName,
//     //   'companyAddress': user.companyAddress,
//     //   'comments': user.comments,
//     //   'accessCode': user.accessCode,
//     //   'fax': user.fax,
//     //   'notes': user.notes,
//     //   'clientId': user.clientId,
//     //   'employeeId': user.employeeId,
//     //   'enforceID': user.enforceID,
//     //   'workLocation': user.workLocation,
//     //   'gender': user.gender,
//     //   'joiningDate': user.joiningDate.toString(),
//     //   'dateOfBirth': user.dateOfBirth.toString(),
//     //   'address': user.address,
//     //   'salary': user.salary,
//     //   'propertyType': user.propertyType,
//     //   'property': user.property,
//     //   'jobType': user.jobType,
//     //   'about': user.about,
//     //   'paymentOptions': user.paymentOptions,
//     //   'accessProperties': user.accessProperties,
//     //   'accessedByClient': user.accessedByClient,
//     //   'isContact': user.isContact,
//     //   'accessedByProperty': user.accessedByProperty,
//     //   'allowDashboard': user.allowDashboard,
//     //   'title': user.title,
//     //   'position': user.position,
//     //   'visibleAccess': user.visibleAccess,
//     //   'country': user.country,
//     //   'area': user.area,
//     //   'zone': user.zone,
//     //   'userId': user.userId,
//     //   'propertyTypes': user.propertyTypes,
//     //   'condoNumber': user.condoNumber,
//     //   'condoName': user.condoName,
//     //   'condoAddress': user.condoAddress,
//     //   'loginId': user.loginId,
//     //   'memberSince': user.memberSince.toString(),
//     //   'homePhone': user.homePhone,
//     //   'businessPhone': user.businessPhone,
//     //   'email2': user.email2,
//     //   'mailingAddress': user.mailingAddress,
//     //   'signature': user.signature,
//     //   'employeeRole': user.employeeRole,
//     //   'mleoId': user.mleoId,
//     //   'defaultShow': user.defaultShow,
//     //   'signVendorId': user.signVendorId,
//     //   'multiZone': user.multiZone,
//     //   'latitude': user.latitude,
//     //   'longitude': user.longitude,
//     //   'holidayRate': user.holidayRate
//     // });

//     // print('body: [${response.body}]');
//     // debugPrint(response.statusCode.toString());
//     // debugPrint(response.toString());
//     // debugPrint(response.body.toString());

//     var update = "original";

//     // if (response != null) {
//     //   print("🐤");
//     //   print(response.body);
//     //   // update = json.decode(response.body.trim());
//     // }

//     if (update == "FAILURE" || update == "original") {
//       print('❌❌ = $update');
//     } else {
//       print('✅✅ = $update');
//     }
//   }

//   // Future<List<User>> getUsers() async {
//   //   List<User> result = [];
//   //   await db.getConnection().then((conn) {
//   //     String sql = 'SELECT * FROM users;';
//   //     conn.query(sql).then((results) {
//   //       for (var row in results) {
//   //         result.add(User(
//   //           id: row[0],
//   //           prefix: row[1],
//   //           firstName: row[2],
//   //           lastName: row[3],
//   //           initials: row[4],
//   //           clientDisplayName: row[5],
//   //           email: row[6],
//   //           mobileNumber: row[7],
//   //           authorityLevel: row[8],
//   //           password: row[9],
//   //           userImage: row[10],
//   //           role: row[11],
//   //           otp: row[12],
//   //           status: row[13],
//   //           enrollServices: row[14],
//   //           companyName: row[15].toString(),
//   //           companyAddress: row[16].toString(),
//   //           comments: row[17].toString(),
//   //           accessCode: row[18].toString(),
//   //           plateNumber: row[19].toString(),
//   //           state: row[20].toString(),
//   //           created: row[21],
//   //           address1: row[22],
//   //           address2: row[23],
//   //           city: row[24],
//   //           province: row[25],
//   //           postalCode: row[26],
//   //           fax: row[27],
//   //           notes: row[28].toString(),
//   //           clientId: row[29].toString(),
//   //           employeeId: row[30],
//   //           enforceID: row[31],
//   //           workLocation: row[32],
//   //           gender: row[33],
//   //           joiningDate: row[34],
//   //           dateOfBirth: row[35],
//   //           address: row[36].toString(),
//   //           salary: row[37],
//   //           propertyType: row[38],
//   //           property: row[39],
//   //           jobType: row[40],
//   //           about: row[41].toString(),
//   //           paymentOptions: row[42].toString(),
//   //           accessProperties: row[43].toString(),
//   //           accessedByClient: row[44],
//   //           isContact: row[45],
//   //           accessedByProperty: row[46],
//   //           allowDashboard: row[47],
//   //           title: row[48].toString(),
//   //           position: row[49].toString(),
//   //           visibleAccess: row[50],
//   //           country: row[51].toString(),
//   //           area: row[52],
//   //           zone: row[53],
//   //           userId: row[54],
//   //           propertyTypes: row[55].toString(),
//   //           condoNumber: row[56].toString(),
//   //           condoName: row[57].toString(),
//   //           condoAddress: row[58].toString(),
//   //           loginId: row[59],
//   //           memberSince: row[60],
//   //           homePhone: row[61],
//   //           businessPhone: row[62],
//   //           email2: row[63],
//   //           mailingAddress: row[64].toString(),
//   //           signature: row[65].toString(),
//   //           employeeRole: row[66],
//   //           mleoId: row[67],
//   //           defaultShow: row[68],
//   //           signVendorId: row[69],
//   //           multiZone: row[70].toString(),
//   //           latitude: row[71],
//   //           longitude: row[72],
//   //           holidayRate: row[73],
//   //         ));

//   //         // print('😈 ${row[3]} ${row[4]}');
//   //       }
//   //     }, onError: (error) {
//   //       // print('$error');
//   //     }).whenComplete(() {
//   //       conn.close();
//   //     });
//   //   });
//   //   return result;
//   // }

//   // Future<void> createNewUser(User user) async {
//   //   db.getConnection().then((conn) {
//   //     //province = 10, otp = 20, enforceId = 30, about = 40, country = 50, homephome = 60, latitude = 70
//   //     String sql =
//   //         'insert into users (prefix, name, last_name, email, mobile, plateNumber, state, address1, address2, city, province, postal_code, password, status, created, initials, client_display_name, auth_level, role, otp, enrollServices, companyName, companyAddress, comments, accessCode, fax, notes, clientID, employeeId, enforceId, work_location, gender, joining_date, date_of_birth, address, salary, property_type, property, job_type, about, payment_options, access_properties, accessed_by_client, is_contact, accessed_by_property, allow_dashboard, title, position, visible_access, country, area, zone, userId, property_types, condo_number, condo_name, condo_addr, login_id, member_since, home_phone, business_phone, email2, mailing_address, signature, employee_role, mleo_id, default_show, signvendorId, multi_zone, latitude, longitude, holiday_rate) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?, ?, ?, ?, ?)';
//   //     conn.query(sql, [
//   //       user.prefix,
//   //       user.firstName,
//   //       user.lastName,
//   //       user.email,
//   //       user.mobileNumber,
//   //       user.plateNumber ?? '',
//   //       user.state ?? '',
//   //       user.address1,
//   //       user.address2,
//   //       user.city,
//   //       user.province, //10
//   //       user.postalCode,
//   //       user.password,
//   //       user.status,
//   //       user.created,
//   //       user.initials,
//   //       user.clientDisplayName,
//   //       user.authorityLevel,
//   //       user.role,
//   //       user.otp,
//   //       user.enrollServices,
//   //       user.companyName,
//   //       user.companyAddress,
//   //       user.comments,
//   //       user.accessCode,
//   //       user.fax,
//   //       user.notes,
//   //       user.clientId,
//   //       user.employeeId,
//   //       user.enforceID,
//   //       user.workLocation,
//   //       user.gender,
//   //       user.joiningDate,
//   //       user.dateOfBirth,

//   //       user.address,
//   //       user.salary,
//   //       user.propertyType,
//   //       user.property,
//   //       user.jobType,
//   //       user.about,
//   //       user.paymentOptions,
//   //       user.accessProperties,
//   //       user.accessedByClient,
//   //       user.isContact,
//   //       user.accessedByProperty,
//   //       user.allowDashboard,
//   //       user.title,
//   //       user.position,
//   //       user.visibleAccess,
//   //       user.country,
//   //       user.area,
//   //       user.zone,
//   //       user.userId,
//   //       user.propertyTypes,
//   //       user.condoNumber,
//   //       user.condoName,
//   //       user.condoAddress,
//   //       user.loginId,
//   //       user.memberSince,
//   //       user.homePhone,
//   //       user.businessPhone,
//   //       user.email2,
//   //       user.mailingAddress,
//   //       user.signature,
//   //       user.employeeRole,
//   //       user.mleoId,
//   //       user.defaultShow,
//   //       user.signVendorId,
//   //       user.multiZone,
//   //       user.latitude,
//   //       user.longitude,
//   //       user.holidayRate
//   //     ]).then((result) {
//   //       // print('✅ Inserted user!');
//   //     }, onError: (error) {
//   //       // print('❌ Error creating user: $error');
//   //     }).whenComplete(() {
//   //       conn.close();
//   //     });
//   //   });
//   // }

//   Future<void> updateUser(User user) async {
//     var url = Uri.parse('http://10.0.2.2/updateuser.php');
//     // var url = Uri.parse('http://localhost/updateuser.php');
//     var response = await http.post(url, body: {
//       'email': user.email,
//       'full_name': user.full_name,
//       'mobileNumber': user.mobile_number,
//       'apartmentNumber': user.unit_number,
//       'address': user.address,
//       'city': user.city,
//       'province': user.province,
//       'postalCode': user.postal_code,
//       'companyAddress': user.company_address,
//       'password': user.password
//     });

//     var update = json.decode(response.body);

//     if (update == "FAILURE") {
//       print('❌❌');
//     } else {
//       print('✅✅');
//     }
//   }

//   Future<void> deleteUser(User user) async {
//     var url = Uri.parse('http://localhost/deleteuser.php');
//     var response = await http.post(url, body: {
//       'email': user.email,
//     });

//     var update = json.decode(response.body);

//     if (update == "FAILURE") {
//       print('❌❌');
//     } else {
//       print('✅✅');
//     }
//   }
// }






// // *** OLD WAYS TO CONNECT TO DATABASE USING PACKAGE MYSQL1 ****


//   // Future<void> updateUser2(User user) async {
//   //   // db.getConnection().then((conn) {
//   //   //   //province = 10, otp = 20, enforceId = 30, about = 40, country = 50, homephome = 60, latitude = 70
//   //   //   String sql =
//   //   //       'UPDATE users SET prefix = ?, name = ?, last_name = ?, email = ?, mobile = ?, plateNumber = ?, state = ?, address1 = ?, address2 = ?, city = ?, province = ?, postal_code = ?, password = ?, status = ?, created = ?, initials = ?, client_display_name = ?, auth_level = ?, role = ?, otp = ?, enrollServices = ?, companyName = ?, companyAddress = ?, comments = ?, accessCode = ?, fax = ?, notes = ?, clientID = ?, employeeId = ?, enforceId = ?, work_location = ?, gender = ?, joining_date = ?, date_of_birth = ?, address = ?, salary = ?, property_type = ?, property = ?, job_type = ?, about = ?, payment_options = ?, access_properties = ?, accessed_by_client = ?, is_contact = ?, accessed_by_property = ?, allow_dashboard = ?, title = ?, position = ?, visible_access = ?, country = ?, area = ?, zone = ?, userId = ?, property_types = ?, condo_number = ?, condo_name = ?, condo_addr = ?, login_id = ?, member_since = ?, home_phone = ?, business_phone = ?, email2 = ?, mailing_address = ?, signature = ?, employee_role = ?, mleo_id = ?, default_show = ?, signvendorId = ?, multi_zone = ?, latitude = ?, longitude = ?, holiday_rate = ? WHERE user_id = ${user.id}';

//   //   //   conn.query(sql, [
//   //   //     user.prefix,
//   //   //     user.firstName,
//   //   //     user.lastName,
//   //   //     user.email,
//   //   //     user.mobileNumber,
//   //   //     user.plateNumber ?? '',
//   //   //     user.state ?? '',
//   //   //     user.address1,
//   //   //     user.address2,
//   //   //     user.city,
//   //   //     user.province, //10
//   //   //     user.postalCode,
//   //   //     user.password,
//   //   //     user.status,
//   //   //     user.created,
//   //   //     user.initials,
//   //   //     user.clientDisplayName,
//   //   //     user.authorityLevel,
//   //   //     user.role,
//   //   //     user.otp,
//   //   //     user.enrollServices,
//   //   //     user.companyName,
//   //   //     user.companyAddress,
//   //   //     user.comments,
//   //   //     user.accessCode,
//   //   //     user.fax,
//   //   //     user.notes,
//   //   //     user.clientId,
//   //   //     user.employeeId,
//   //   //     user.enforceID,
//   //   //     user.workLocation,
//   //   //     user.gender,
//   //   //     user.joiningDate,
//   //   //     user.dateOfBirth,
//   //   //     user.address,
//   //   //     user.salary,
//   //   //     user.propertyType,
//   //   //     user.property,
//   //   //     user.jobType,
//   //   //     user.about,
//   //   //     user.paymentOptions,
//   //   //     user.accessProperties,
//   //   //     user.accessedByClient,
//   //   //     user.isContact,
//   //   //     user.accessedByProperty,
//   //   //     user.allowDashboard,
//   //   //     user.title,
//   //   //     user.position,
//   //   //     user.visibleAccess,
//   //   //     user.country,
//   //   //     user.area,
//   //   //     user.zone,
//   //   //     user.userId,
//   //   //     user.propertyTypes,
//   //   //     user.condoNumber,
//   //   //     user.condoName,
//   //   //     user.condoAddress,
//   //   //     user.loginId,
//   //   //     user.memberSince,
//   //   //     user.homePhone,
//   //   //     user.businessPhone,
//   //   //     user.email2,
//   //   //     user.mailingAddress,
//   //   //     user.signature,
//   //   //     user.employeeRole,
//   //   //     user.mleoId,
//   //   //     user.defaultShow,
//   //   //     user.signVendorId,
//   //   //     user.multiZone,
//   //   //     user.latitude,
//   //   //     user.longitude,
//   //   //     user.holidayRate,
//   //   //   ]).then((result) {
//   //   //     // print('✅ updated user!');
//   //   //   }, onError: (error) {
//   //   //     // print('❌ Error creating user: $error');
//   //   //   }).whenComplete(() {
//   //   //     conn.close();
//   //   //   });
//   //   // });
//   // }


//   // Future<void> deleteUser2(User user) async {
//   //   // db.getConnection().then((conn) {
//   //   //   //province = 10, otp = 20, enforceId = 30, about = 40, country = 50, homephome = 60, latitude = 70
//   //   //   String sql = 'Delete from users where user_id=?';
//   //   //   conn.query(sql, [user.id]).then((result) {
//   //   //     // print('✅ Deleted User!');
//   //   //   }, onError: (error) {
//   //   //     // print('❌ Error deleting user: $error');
//   //   //   });
//   //   // });
//   // }
// import 'package:flutter/material.dart';
// import 'package:r2park_flutter_dev/models/property.dart';
// import 'package:r2park_flutter_dev/models/self_registration.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ExemptionRequestManager {
//   // Mysql db;

//   // ExemptionRequestManager() : db = Mysql();

//   Future<List<Property>> getProperties() async {
//     //FOR ANDROID SIMULATOR *********
//     // var url = Uri.parse('http://10.0.2.2/getproperties.php');
//     //FOR iOS SIMULATOR AND WEB **********
//     var url = Uri.parse('http://localhost/getproperties.php');

//     var response = await http.get(url);

//     var properties = json.decode(response.body);
//     final List databasePropertyList = json.decode(response.body);

//     List<Property> propertyList = databasePropertyList
//         .map((val) => Property.convertFromJson(val))
//         .toList();

//     if (properties == "ERROR GETTING USERS") {
//       return [];
//     } else {
//       return propertyList;
//     }
//   }

//   Future<void> createExemptionRequest(SelfRegistration selfRegistration) async {
//     var url = Uri.parse('http://localhost/insertexemption.php');
//     var response = await http.post(url, body: {
//       "Reg_Date": selfRegistration.regDate.toString(),
//       "fk_Plate_ID": selfRegistration.plateID,
//       "fk_property_id": selfRegistration.propertyID,
//       "Start_Date": selfRegistration.startDate.toString(),
//       "End_Date": selfRegistration.endDate.toString(),
//       "Unit_No": selfRegistration.unitNumber,
//       "Street_Name": selfRegistration.streetName,
//       "fk_Zone_ID": selfRegistration.zoneID,
//       "email": selfRegistration.email,
//       "Phone": selfRegistration.phone,
//       "Name": selfRegistration.name,
//       "Make_Model": selfRegistration.makeModel,
//       "Days": selfRegistration.numberOfDays,
//       "Reason": selfRegistration.reason,
//       "Notes": selfRegistration.notes,
//       "Auth_By": selfRegistration.authBy,
//       "IsArchived": selfRegistration.isArchived,
//       "street_number": selfRegistration.streetNumber,
//       "street_suffix": selfRegistration.streetSuffix,
//       "address": selfRegistration.address
//     });

//     debugPrint(response.statusCode.toString());
//     debugPrint(response.toString());
//     debugPrint(response.body.toString());

//     var update = "";

//     if (response.body.isNotEmpty) {
//       update = json.decode(response.body);
//     }

//     if (update == "FAILURE" || update == "") {
//       // print('❌❌');
//     } else {
//       // print('✅✅');
//     }
//   }

//   Future<void> createExemptionRequest2(
//       SelfRegistration selfRegistration) async {
//     // await db.getConnection().then((conn) {
//     //   String sql =
//     //       'insert into pp_self_reg (Reg_Date, fk_Plate_ID, fk_property_id, Start_Date, End_Date, Unit_No, Street_Name, fk_Zone_ID, email, Phone, Name, Make_Model, Days, Reason, Notes, Auth_By, IsArchived, street_number, street_suffix, address) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
//     //   // String sql =
//     //   // 'insert into municipal_exemptions (municipal_id, name, email, phone, street, street_name, street_exemption, street_name_exemption, reason, municipality, start_date, time_exemption, plateno, province, vehicle_type, requested_days, end_date, created) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
//     //   conn
//     //       .query(sql, [
//     //         // selfRegistration.registryID,
//     //         selfRegistration.regDate,
//     //         selfRegistration.plateID,
//     //         selfRegistration.propertyID,
//     //         selfRegistration.startDate,
//     //         selfRegistration.endDate,
//     //         selfRegistration.unitNumber,
//     //         selfRegistration.streetName,
//     //         selfRegistration.zoneID,
//     //         selfRegistration.email,
//     //         selfRegistration.phone,
//     //         selfRegistration.name,
//     //         selfRegistration.makeModel,
//     //         selfRegistration.numberOfDays,
//     //         selfRegistration.reason,
//     //         selfRegistration.notes,
//     //         selfRegistration.authBy,
//     //         selfRegistration.isArchived,
//     //         selfRegistration.streetNumber,
//     //         selfRegistration.streetSuffix,
//     //         selfRegistration.address

//     //         // exemption.municipal_id,
//     //         // exemption.name,
//     //         // exemption.email,
//     //         // exemption.phone,
//     //         // exemption.streetNumber,
//     //         // exemption.streetName,
//     //         // exemption.streetExemption,
//     //         // exemption.streetNameExemption,
//     //         // exemption.reason,
//     //         // exemption.municipality,
//     //         // exemption.startDate,
//     //         // exemption.timeExemption,
//     //         // exemption.plateNumber,
//     //         // exemption.province,
//     //         // exemption.vehicleType,
//     //         // exemption.requestedDays,
//     //         // exemption.endDate,
//     //         // exemption.created
//     //       ])
//     //       .then((result) {}, onError: (error) {})
//     //       .whenComplete(() {
//     //         conn.close();
//     //       });
//     // });
//   }

//   Future<List<Property>>? then(
//       Future<List<Property>> Function(ExemptionRequestManager exemptionManager)
//           param0) {
//     return null;
//   }
// }



// // *** OLD WAYS TO CONNECT TO DATABASE USING PACKAGE MYSQL1 ****
//   // Future<List<Property>> getProperties2() async {
//   //   List<Property> result = [];
//   //   // await db.getConnection().then((conn) {
//   //   //   String sql = 'SELECT * FROM properties;';
//   //   //   conn.query(sql).then((results) {
//   //   //     for (var row in results) {
//   //   //       result.add(
//   //   //         Property(
//   //   //           id: row[0],
//   //   //           clientID: row[1],
//   //   //           propertyName: row[2],
//   //   //           propertyID: row[3],
//   //   //           propertyType: row[4],
//   //   //           allocatedEmployees: row[5],
//   //   //           parkingSpace: row[6],
//   //   //           propertyAddress: row[7],
//   //   //           agreementImage: row[8],
//   //   //           propertyImage: row[9],
//   //   //           moreInformation: row[10].toString(),
//   //   //           createdAt: row[11],
//   //   //           latitude: row[12],
//   //   //           longitude: row[13],
//   //   //           qrCode: row[14],
//   //   //           status: row[15],
//   //   //           country: row[16],
//   //   //           province: row[17],
//   //   //           area: row[18],
//   //   //           zone: row[19],
//   //   //           propertyID2: row[20],
//   //   //           noUnites: row[21],
//   //   //           numObs: row[22],
//   //   //           timeRestrictions: row[23].toString(),
//   //   //           siteDescription: row[24].toString(),
//   //   //           workInstructions: row[25].toString(),
//   //   //           isValtag: row[26],
//   //   //           municipalTicketAddress: row[27].toString(),
//   //   //         ),
//   //   //       );

//   //   //       // print('${row[2]}, ${row[3]}');
//   //   //     }
//   //   //   }, onError: (error) {
//   //   //     // print('Error getting properties: $error');
//   //   //   }).whenComplete(() {
//   //   //     conn.close();
//   //   //   });
//   //   // });
//   //   return result;
//   // }

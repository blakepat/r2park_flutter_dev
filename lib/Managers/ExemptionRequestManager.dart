import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/self_registration.dart';

import '../models/mysql.dart';

class ExemptionRequestManager {
  Mysql db;

  ExemptionRequestManager() : db = Mysql();

  Future<List<Property>> getProperties() async {
    List<Property> result = [];
    await db.getConnection().then((conn) {
      String sql = 'SELECT * FROM properties;';
      conn.query(sql).then((results) {
        for (var row in results) {
          result.add(
            Property(
              id: row[0],
              clientID: row[1],
              propertyName: row[2],
              propertyID: row[3],
              propertyType: row[4],
              allocatedEmployees: row[5],
              parkingSpace: row[6],
              propertyAddress: row[7],
              agreementImage: row[8],
              propertyImage: row[9],
              moreInformation: row[10].toString(),
              createdAt: row[11],
              latitude: row[12],
              longitude: row[13],
              qrCode: row[14],
              status: row[15],
              country: row[16],
              province: row[17],
              area: row[18],
              zone: row[19],
              propertyID2: row[20],
              noUnites: row[21],
              numObs: row[22],
              timeRestrictions: row[23].toString(),
              siteDescription: row[24].toString(),
              workInstructions: row[25].toString(),
              isValtag: row[26],
              municipalTicketAddress: row[27].toString(),
            ),
          );

          print('${row[2]}, ${row[3]}');
        }
      }, onError: (error) {
        print('Error getting properties: $error');
      }).whenComplete(() {
        conn.close();
      });
    });
    return result;
  }

  Future<void> createExemptionRequest(SelfRegistration selfRegistration) async {
    await db.getConnection().then((conn) {
      String sql =
          'insert into pp_self_reg (Reg_Date, fk_Plate_ID, fk_property_id, Start_Date, End_Date, Unit_No, Street_Name, fk_Zone_ID, email, Phone, Name, Make_Model, Days, Reason, Notes, Auth_By, IsArchived, street_number, street_suffix, address) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
      // String sql =
      // 'insert into municipal_exemptions (municipal_id, name, email, phone, street, street_name, street_exemption, street_name_exemption, reason, municipality, start_date, time_exemption, plateno, province, vehicle_type, requested_days, end_date, created) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
      conn.query(sql, [
        // selfRegistration.registryID,
        selfRegistration.regDate,
        selfRegistration.plateID,
        selfRegistration.propertyID,
        selfRegistration.startDate,
        selfRegistration.endDate,
        selfRegistration.unitNumber,
        selfRegistration.streetName,
        selfRegistration.zoneID,
        selfRegistration.email,
        selfRegistration.phone,
        selfRegistration.name,
        selfRegistration.makeModel,
        selfRegistration.numberOfDays,
        selfRegistration.reason,
        selfRegistration.notes,
        selfRegistration.authBy,
        selfRegistration.isArchived,
        selfRegistration.streetNumber,
        selfRegistration.streetSuffix,
        selfRegistration.address

        // exemption.municipal_id,
        // exemption.name,
        // exemption.email,
        // exemption.phone,
        // exemption.streetNumber,
        // exemption.streetName,
        // exemption.streetExemption,
        // exemption.streetNameExemption,
        // exemption.reason,
        // exemption.municipality,
        // exemption.startDate,
        // exemption.timeExemption,
        // exemption.plateNumber,
        // exemption.province,
        // exemption.vehicleType,
        // exemption.requestedDays,
        // exemption.endDate,
        // exemption.created
      ]).then((result) {
        print('✅ created exemption!');
      }, onError: (error) {
        print('❌ Error creating exemption: $error');
      }).whenComplete(() {
        conn.close();
      });
    });
  }
}

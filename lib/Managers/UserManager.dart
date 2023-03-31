import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/models/mysql.dart';
import '../models/user.dart';

class UserManager {
  Mysql db;

  UserManager() : db = new Mysql();

  Future<List<User>> getUsers() async {
    List<User> result = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM users;';
      conn.query(sql).then((results) {
        for (var row in results) {
          result.add(User(
            id: row[0],
            prefix: row[1],
            firstName: row[2],
            lastName: row[3],
            initials: row[4],
            clientDisplayName: row[5],
            email: row[6],
            mobileNumber: row[7],
            authorityLevel: row[8],
            password: row[9],
            userImage: row[10],
            role: row[11],
            otp: row[12],
            status: row[13],
            enrollServices: row[14],
            companyName: row[15].toString(),
            companyAddress: row[16].toString(),
            comments: row[17].toString(),
            accessCode: row[18].toString(),
            plateNumber: row[19].toString(),
            state: row[20].toString(),
            created: row[21],
            address1: row[22],
            address2: row[23],
            city: row[24],
            province: row[25],
            postalCode: row[26],
            fax: row[27],
            notes: row[28].toString(),
            clientId: row[29].toString(),
            employeeId: row[30],
            enforceID: row[31],
            workLocation: row[32],
            gender: row[33],
            joiningDate: row[34],
            dateOfBirth: row[35],
            address: row[36].toString(),
            salary: row[37],
            propertyType: row[38],
            property: row[39],
            jobType: row[40],
            about: row[41].toString(),
            paymentOptions: row[42].toString(),
            accessProperties: row[43].toString(),
            accessedByClient: row[44],
            isContact: row[45],
            accessedByProperty: row[46],
            allowDashboard: row[47],
            title: row[48].toString(),
            position: row[49].toString(),
            visibleAccess: row[50],
            country: row[51].toString(),
            area: row[52],
            zone: row[53],
            userId: row[54],
            propertyTypes: row[55].toString(),
            condoNumber: row[56].toString(),
            condoName: row[57].toString(),
            condoAddress: row[58].toString(),
            loginId: row[59],
            memberSince: row[60],
            homePhone: row[61],
            businessPhone: row[62],
            email2: row[63],
            mailingAddress: row[64].toString(),
            signature: row[65].toString(),
            employeeRole: row[66],
            mleoId: row[67],
            defaultShow: row[68],
            signVendorId: row[69],
            multiZone: row[70].toString(),
            latitude: row[71],
            longitude: row[72],
            holidayRate: row[73],
          ));

          // print('😈 ${row[3]} ${row[4]}');
        }
      }, onError: (error) {
        print('$error');
      }).whenComplete(() {
        conn.close();
      });
    });
    return result;
  }

  Future<void> createNewUser(User user) async {
    db.getConnection().then((conn) {
      //province = 10, otp = 20, enforceId = 30, about = 40, country = 50, homephome = 60, latitude = 70
      String sql =
          'insert into users (prefix, name, last_name, email, mobile, plateNumber, state, address1, address2, city, province, postal_code, password, status, created, initials, client_display_name, auth_level, role, otp, enrollServices, companyName, companyAddress, comments, accessCode, fax, notes, clientID, employeeId, enforceId, work_location, gender, joining_date, date_of_birth, address, salary, property_type, property, job_type, about, payment_options, access_properties, accessed_by_client, is_contact, accessed_by_property, allow_dashboard, title, position, visible_access, country, area, zone, userId, property_types, condo_number, condo_name, condo_addr, login_id, member_since, home_phone, business_phone, email2, mailing_address, signature, employee_role, mleo_id, default_show, signvendorId, multi_zone, latitude, longitude, holiday_rate) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?, ?, ?, ?, ?)';
      conn.query(sql, [
        user.prefix,
        user.firstName,
        user.lastName,
        user.email,
        user.mobileNumber,
        user.plateNumber ?? '',
        user.state ?? '',
        user.address1,
        user.address2,
        user.city,
        user.province, //10
        user.postalCode,
        user.password,
        user.status,
        user.created,
        user.initials,
        user.clientDisplayName,
        user.authorityLevel,
        user.role,
        user.otp,
        user.enrollServices,
        user.companyName,
        user.companyAddress,
        user.comments,
        user.accessCode,
        user.fax,
        user.notes,
        user.clientId,
        user.employeeId,
        user.enforceID,
        user.workLocation,
        user.gender,
        user.joiningDate,
        user.dateOfBirth,
        user.address,
        user.salary,
        user.propertyType,
        user.property,
        user.jobType,
        user.about,
        user.paymentOptions,
        user.accessProperties,
        user.accessedByClient,
        user.isContact,
        user.accessedByProperty,
        user.allowDashboard,
        user.title,
        user.position,
        user.visibleAccess,
        user.country,
        user.area,
        user.zone,
        user.userId,
        user.propertyTypes,
        user.condoNumber,
        user.condoName,
        user.condoAddress,
        user.loginId,
        user.memberSince,
        user.homePhone,
        user.businessPhone,
        user.email2,
        user.mailingAddress,
        user.signature,
        user.employeeRole,
        user.mleoId,
        user.defaultShow,
        user.signVendorId,
        user.multiZone,
        user.latitude,
        user.longitude,
        user.holidayRate
      ]).then((result) {
        print('✅ Inserted user!');
      }, onError: (error) {
        print('❌ Error creating user: $error');
      }).whenComplete(() {
        conn.close();
      });
    });
  }

  Future<void> updateUser(User user) async {
    print('😀 ${user.id}');
    print('😀 ${user.firstName}');
    db.getConnection().then((conn) {
      //province = 10, otp = 20, enforceId = 30, about = 40, country = 50, homephome = 60, latitude = 70
      String sql =
          'UPDATE users SET prefix = ?, name = ?, last_name = ?, email = ?, mobile = ?, plateNumber = ?, state = ?, address1 = ?, address2 = ?, city = ?, province = ?, postal_code = ?, password = ?, status = ?, created = ?, initials = ?, client_display_name = ?, auth_level = ?, role = ?, otp = ?, enrollServices = ?, companyName = ?, companyAddress = ?, comments = ?, accessCode = ?, fax = ?, notes = ?, clientID = ?, employeeId = ?, enforceId = ?, work_location = ?, gender = ?, joining_date = ?, date_of_birth = ?, address = ?, salary = ?, property_type = ?, property = ?, job_type = ?, about = ?, payment_options = ?, access_properties = ?, accessed_by_client = ?, is_contact = ?, accessed_by_property = ?, allow_dashboard = ?, title = ?, position = ?, visible_access = ?, country = ?, area = ?, zone = ?, userId = ?, property_types = ?, condo_number = ?, condo_name = ?, condo_addr = ?, login_id = ?, member_since = ?, home_phone = ?, business_phone = ?, email2 = ?, mailing_address = ?, signature = ?, employee_role = ?, mleo_id = ?, default_show = ?, signvendorId = ?, multi_zone = ?, latitude = ?, longitude = ?, holiday_rate = ? WHERE user_id = ${user.id}';

      conn.query(sql, [
        user.prefix,
        user.firstName,
        user.lastName,
        user.email,
        user.mobileNumber,
        user.plateNumber ?? '',
        user.state ?? '',
        user.address1,
        user.address2,
        user.city,
        user.province, //10
        user.postalCode,
        user.password,
        user.status,
        user.created,
        user.initials,
        user.clientDisplayName,
        user.authorityLevel,
        user.role,
        user.otp,
        user.enrollServices,
        user.companyName,
        user.companyAddress,
        user.comments,
        user.accessCode,
        user.fax,
        user.notes,
        user.clientId,
        user.employeeId,
        user.enforceID,
        user.workLocation,
        user.gender,
        user.joiningDate,
        user.dateOfBirth,
        user.address,
        user.salary,
        user.propertyType,
        user.property,
        user.jobType,
        user.about,
        user.paymentOptions,
        user.accessProperties,
        user.accessedByClient,
        user.isContact,
        user.accessedByProperty,
        user.allowDashboard,
        user.title,
        user.position,
        user.visibleAccess,
        user.country,
        user.area,
        user.zone,
        user.userId,
        user.propertyTypes,
        user.condoNumber,
        user.condoName,
        user.condoAddress,
        user.loginId,
        user.memberSince,
        user.homePhone,
        user.businessPhone,
        user.email2,
        user.mailingAddress,
        user.signature,
        user.employeeRole,
        user.mleoId,
        user.defaultShow,
        user.signVendorId,
        user.multiZone,
        user.latitude,
        user.longitude,
        user.holidayRate,
      ]).then((result) {
        print('✅ updated user!');
      }, onError: (error) {
        print('❌ Error creating user: $error');
      }).whenComplete(() {
        conn.close();
      });
    });
  }
}

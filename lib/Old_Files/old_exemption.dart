// class Exemption {
//   int? id;
//   int? municipalId;
//   String? name;
//   String? email;
//   String? phone;
//   String? streetNumber;
//   String? streetName;
//   String? streetExemption;
//   String? streetNameExemption;
//   String? reason;
//   String? municipality;
//   DateTime? startDate;
//   DateTime? timeExemption;
//   String? plateNumber;
//   String? province;
//   String? vehicleType;
//   int? requestedDays;
//   DateTime? endDate;
//   DateTime? created;

//   Exemption(
//       {required this.id,
//       this.municipalId,
//       this.name,
//       this.email,
//       this.phone,
//       this.streetNumber,
//       this.streetName,
//       this.streetExemption,
//       this.streetNameExemption,
//       this.reason,
//       this.municipality,
//       this.startDate,
//       this.timeExemption,
//       this.plateNumber,
//       this.province,
//       this.vehicleType,
//       this.requestedDays,
//       this.endDate,
//       this.created});

//   Exemption.def() {
//     id = null;
//     municipalId = 0;
//     streetName = '';
//     email = '';
//     phone = '';
//     streetNumber = '';
//     streetName = '';
//     streetExemption = '';
//     streetNameExemption = '';
//     reason = '';
//     municipality = '';
//     startDate = DateTime.now().toUtc();
//     timeExemption = DateTime.now().toUtc();
//     plateNumber = '';
//     province = '';
//     vehicleType = '';
//     requestedDays = 0;
//     endDate = DateTime.now().toUtc();
//     created = DateTime.now().toUtc();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};

//     // data['user_id'] = userId;
//     data['Registry_ID'] = id;
//     data['fk_property_id'] = municipalId;
//     data['user_id'] = name;
//     data['email'] = email;
//     data['Phone'] = phone;
//     data['user_id'] = streetNumber;
//     data['user_id'] = streetName;
//     data['user_id'] = streetExemption;
//     data['user_id'] = streetNameExemption;
//     data['user_id'] = reason;
//     data['user_id'] = municipality;
//     data['Start_Date'] = startDate;
//     data['user_id'] = timeExemption;
//     data['fk_Plate_ID'] = plateNumber;
//     data['user_id'] = province;
//     data['user_id'] = vehicleType;
//     data['user_id'] = requestedDays;
//     data['End_Date'] = endDate;
//     data['user_id'] = created;

//     return data;
//   }
// }

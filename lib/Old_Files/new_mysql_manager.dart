// import 'package:mysql_manager/src/mysql_manager.dart';
// import 'package:mysql_client/mysql_client.dart';

// // void main() async {
// //   final MySQLManager manager = MySQLManager.instance;

// //   final conn = await manager.init(false, {'db':'parkinm2_r2p-flutter-dev3', 'host': 'localhost', 'user':'root', 'password':'', 'port': 3306});

// // }

// class MySqlManager {
//   final MySQLManager manager = MySQLManager.instance;

//   static String host =
//           'localhost', // static String host = '10.0.2.2', // this is used for android simulator
//       user = 'root',
//       db = 'parkinm2_r2p-flutter-dev3';

//   static int port = 3306;

//   Future<MySQLConnection> getConnection() async {
//     return await manager.init(false, {
//       'db': 'parkinm2_r2p-flutter-dev3',
//       'host': 'localhost',
//       'user': 'root',
//       'password': '',
//       'port': 3306
//     });
//   }
// }

// // class Mysql {
// //   // static String host = '10.0.2.2', // this is used for android simulator
// //   static String host = 'localhost',
// //       user = 'root',
// //       // password = '1234',
// //       db = 'parkinm2_r2p-flutter-dev3';

// //   static int port = 3306;

// //   Mysql();

// //   Future<MySqlConnection> getConnection() async {
// //     var settings =
// //         ConnectionSettings(host: host, port: port, user: user, db: db);

// //     return await MySqlConnection.connect(settings);
// //   }
// // }

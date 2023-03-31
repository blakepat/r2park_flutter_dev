import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/UserManager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';

class SessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  SessionView({required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      SessionScreen(user: user, sessionCubit: sessionCubit);
}

class SessionScreen extends State<SessionView> {
  final User user;
  final SessionCubit sessionCubit;
  final plateController = TextEditingController();
  final cityController = TextEditingController();
  final unitController = TextEditingController();
  final streetController = TextEditingController();
  List<String> licensePlates = List.empty(growable: true);
  String _selectedLicensePlate = "";
  String _selectedDuration = "1";

  var userManager = UserManager();

  @override
  void initState() {
    super.initState();
    // if (user.plateNumber != null) {
    //   licensePlates.addAll(user.plateNumber!);
    // }
  }

  SessionScreen({required this.user, required this.sessionCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _createAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _headerView(),
              _licencePlateForm(),
              _licensePlateList(),
              _cityInput(),
              _unitNumberInput(),
              _streetInput(),
              _durationInput(),
              _submitButton(),
              _footerView()
            ],
          ),
        ),
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => NewUser(user: user)))
                .then((obj) => userManager.updateUser(obj));
          },
        )
      ],
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
      ),
      backgroundColor: Colors.blue,
      title: Text("Register to Park"),
      shadowColor: Colors.black54,
    );
  }

  Widget _headerView() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Text(
        'Register Vehicle',
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _licencePlateForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: plateController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.rectangle_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'add new license plate...',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                )),
          ),
          IconButton(
              onPressed: () {
                _addNewLicensePlate(plateController.text);
                plateController.text = '';
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  void _addNewLicensePlate(String plate) {
    List<String> updatedPlates = List.empty(growable: true);
    //validate plate
    if (plate.isNotEmpty) {
      updatedPlates.addAll(licensePlates);
      updatedPlates.add(plate.toUpperCase());
      sessionCubit.updateLicensePlates(plates: updatedPlates, user: user);
      setState(() => licensePlates.add(plate.toUpperCase()));
    } else {
      //show alert
      print('plate not valid');
    }
  }

  Widget _licensePlateList() {
    final listOfPlates = licensePlates
        .map((plate) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {},
                child: CheckboxListTile(
                  title: Text(
                    plate,
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(),
                  value: _selectedLicensePlate == plate,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      newValue
                          ? setState(() => _selectedLicensePlate = plate)
                          : setState(() => _selectedLicensePlate = '');
                    }
                  },
                ),
              ),
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'License Plate: ${_selectedLicensePlate.toUpperCase().trim()}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView(children: listOfPlates),
          ),
        ],
      ),
    );
  }

  Widget _cityInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: cityController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  hintText: 'Enter city name...',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: streetController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.home_work,
                    color: Colors.white,
                  ),
                  hintText: 'Enter street name',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitNumberInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: unitController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.numbers,
                    color: Colors.white,
                  ),
                  hintText: 'Enter unit number',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationInput() {
    final durationsList = ['1', '2', '3', '4']
        .map(
          (duration) => Container(
            height: 64,
            width: 84,
            child: CheckboxListTile(
              checkColor: Colors.red,
              activeColor: Colors.white,
              title: Text(
                duration,
                style: TextStyle(color: Colors.white),
              ),
              value: duration == _selectedDuration,
              onChanged: (newValue) => setState(() {
                if (newValue != null) {
                  _selectedDuration = duration;
                }
              }),
            ),
          ),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Number of days:',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Row(children: durationsList),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () => _submitPressed(), child: Text('Submit'));
  }

  _submitPressed() {
    print(
        '\nLicense Plate: $_selectedLicensePlate \nCity Name: ${cityController.text} \n Address: ${unitController.text} ${streetController.text} \n Duration: $_selectedDuration \n');
  }

  Widget _footerView() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        user.email ?? 'no email found',
        style: TextStyle(
            color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

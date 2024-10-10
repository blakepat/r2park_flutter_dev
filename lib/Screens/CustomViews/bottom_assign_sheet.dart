import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/models/access_code.dart';

class BottomAssignSheet extends StatefulWidget {
  final AccessCode accessCode;
  const BottomAssignSheet({super.key, required this.accessCode});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _BottomAssignSheetState(accessCode: accessCode);
}

class _BottomAssignSheetState extends State<BottomAssignSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final AccessCode accessCode;

  _BottomAssignSheetState({required this.accessCode});

  @override
  void initState() {
    super.initState();
    _nameController.text = accessCode.name ?? "";
    _emailController.text = accessCode.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 305,
      decoration: BoxDecoration(
        color: backgroundBlueGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Assign Access Code To:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    _closeBottomSheet();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  iconSize: 14,
                  constraints: BoxConstraints(maxHeight: 36.0, maxWidth: 36.0),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: textFieldDecoration(
                  icon: Icons.person, labelName: 'Full Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration:
                  textFieldDecoration(icon: Icons.email, labelName: 'Email'),
            ),
          ),
          GradientButton(
              borderRadius: BorderRadius.circular(12),
              onPressed: () {
                _assignAccessCode();
              },
              child: Text(
                "Assign",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  void _assignAccessCode() {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      Navigator.pop(context, [_nameController.text, _emailController.text]);
    } else {
      //TODO: SHOW POP UP TELLING THEM TO FILL OUT FORMS
    }
  }

  void _closeBottomSheet() {
    Navigator.pop(context);
  }
}

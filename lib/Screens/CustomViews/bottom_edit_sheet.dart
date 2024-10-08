import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/models/access_code.dart';

class BottomEditSheet extends StatefulWidget {
  final AccessCode accessCode;
  const BottomEditSheet({super.key, required this.accessCode});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      _BottomEditSheetState(accessCode: accessCode);
}

class _BottomEditSheetState extends State<BottomEditSheet> {
  final _descriptionTextField = TextEditingController();
  final _durationTextField = TextEditingController();

  final AccessCode accessCode;

  _BottomEditSheetState({required this.accessCode});

  @override
  void initState() {
    super.initState();
    _descriptionTextField.text = accessCode.description ?? "";
    _durationTextField.text = accessCode.duration ?? "";
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
                    "Edit Access Code:",
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
              controller: _descriptionTextField,
              decoration: textFieldDecoration(
                  icon: Icons.notes, labelName: 'Description'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _durationTextField,
              decoration: textFieldDecoration(
                  icon: Icons.punch_clock_rounded, labelName: 'Duration'),
            ),
          ),
          GradientButton(
              borderRadius: BorderRadius.circular(12),
              onPressed: () {
                _editAccessCode();
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  void _editAccessCode() {
    if (_descriptionTextField.text.isNotEmpty &&
        _durationTextField.text.isNotEmpty) {
      Navigator.pop(
          context, [_descriptionTextField.text, _durationTextField.text]);
    } else {
      print("SHOW POP UP TELLING THEM TO FILL OUT FORMS");
    }
  }

  void _closeBottomSheet() {
    Navigator.pop(context);
  }
}

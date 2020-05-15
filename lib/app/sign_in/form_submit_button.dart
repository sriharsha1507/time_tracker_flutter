import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({@required String text, @required VoidCallback onPressed})
      : super(
            height: 44.0,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black87,
              ),
            ),
            borderRadius: 4.0,
            onPressed: onPressed,
            color: Colors.yellow);
}

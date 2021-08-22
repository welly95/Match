import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class BasicTextField extends StatelessWidget {
  final ValueKey<String?> key;
  final TextEditingController basicTextController;
  final String hintText;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  BasicTextField(this.key, this.basicTextController, this.hintText, this.inputType, this.validator);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        controller: basicTextController,
        // onChanged: (value) {
        //   basicTextController.text = value;
        // },
        onSaved: (value) {
          basicTextController.text = value!;
        },
        validator: validator,
        keyboardType: inputType,
        autocorrect: false,
        style: TextStyles.body,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.grey, width: 1.0),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // disabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.grey, width: 1.0),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyles.textFieldsHint,
          // focusColor: Colors.black54,
          // hoverColor: Colors.black54,
        ),
      ),
    );
  }
}

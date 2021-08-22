import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class ObscureTextField extends StatefulWidget {
  final ValueKey<String?> key;
  final TextEditingController obscureTextController;
  final String hintText;
  final String? Function(String?) validator;

  ObscureTextField(this.key, this.obscureTextController, this.hintText, this.validator);

  @override
  _ObscureTextFieldState createState() => _ObscureTextFieldState();
}

class _ObscureTextFieldState extends State<ObscureTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        key: widget.key,
        controller: widget.obscureTextController,
        obscureText: _obscureText,
        // onChanged: (value) {
        //   widget.obscureTextController.text = value;
        // },
        keyboardType: TextInputType.text,
        validator: widget.validator,
        style: TextStyles.elMessiri,
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
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
              print(_obscureText.toString());
            },
            icon: Icon(
              (_obscureText) ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
              color: Colors.orange,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyles.textFieldsHint,
        ),
      ),
    );
  }
}

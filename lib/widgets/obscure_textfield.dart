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
  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        key: widget.key,
        controller: widget.obscureTextController,
        //ToDo searching for problem that obscure text doesn't work!
        obscureText: _obscureText,
        // onChanged: (value) {
        //   widget.obscureTextController.text = value;
        // },
        keyboardType: TextInputType.text,
        validator: widget.validator,
        style: TextStyles.elMessiri,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white70,
          filled: true,
          suffixIcon: IconButton(
            //ToDo searching for problem that obscure text doesn't work!
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
              print(_obscureText.toString());
            },
            icon: Icon(
              (_obscureText) ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyles.textFieldsHint,
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/widgets/basic_textfield.dart';
import 'package:modon_screens/widgets/buttons/styled_rounded_loading_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    RoundedLoadingButtonController _okButtonController = RoundedLoadingButtonController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.2,
                width: SizeConfig.screenWidth!,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Forget Your Password',
                    style: TextStyles.h2Bold,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Please enter your email address',
                    style: TextStyles.h4,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.15,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.1,
                width: SizeConfig.screenWidth! * 0.85,
                child: BasicTextField(
                  ValueKey('Email'),
                  emailController,
                  'Email',
                  TextInputType.emailAddress,
                  (value) {},
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.15,
                width: SizeConfig.screenWidth!,
              ),
              StyledRoundedLoadingButton(
                buttonController: _okButtonController,
                label: 'Ok',
                onPressed: () {
                  FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((_) {
                    Fluttertoast.showToast(
                      msg: 'A Password reset link has been send to your Email.',
                      gravity: ToastGravity.TOP,
                      toastLength: Toast.LENGTH_LONG,
                    ).then((_) => Navigator.of(context).pop());
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

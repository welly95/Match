import 'package:flutter/material.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/widgets/basic_textfield.dart';
import 'package:modon_screens/widgets/buttons/basic_button.dart';

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
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
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
                width: SizeConfig.screenWidth! * 0.85,
                child: BasicButton(buttonName: 'Ok', onPressedFunction: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/forget_password.dart';
import 'package:modon_screens/screens/otp.dart';
import 'package:modon_screens/widgets/basic_textfield.dart';
import 'package:modon_screens/widgets/buttons/basic_button.dart';
import 'package:modon_screens/widgets/obscure_textfield.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool? _agree;
  @override
  void initState() {
    _agree = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController signInEmailController = TextEditingController();
    TextEditingController signInPasswordController = TextEditingController();
    TextEditingController signUpNameController = TextEditingController();
    TextEditingController signUpNumberController = TextEditingController();
    TextEditingController signUpEmailController = TextEditingController();
    TextEditingController signUpAddressController = TextEditingController();
    TextEditingController signUpPasswordController = TextEditingController();

    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: SizedBox(
              child: Text(
                'MATCH',
                style: TextStyles.h1,
              ),
              height: SizeConfig.screenHeight! * 0.25,
              width: SizeConfig.screenWidth!,
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size(SizeConfig.safeBlockHorizontal!, SizeConfig.safeBlockVertical! * 4),
              child: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                indicator: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                tabs: <Widget>[
                  Tab(
                    child: FittedBox(
                      child: Text(
                        'Sign Up',
                        style: TextStyles.h1,
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Text(
                        'Sign In',
                        style: TextStyles.h1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.08,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: BasicTextField(
                      ValueKey('Name'),
                      signUpNameController,
                      'Full Name',
                      TextInputType.name,
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: BasicTextField(
                      ValueKey('Phone'),
                      signUpNumberController,
                      'Phone Number',
                      TextInputType.phone,
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: BasicTextField(
                      ValueKey('Email'),
                      signUpEmailController,
                      'Email',
                      TextInputType.emailAddress,
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: BasicTextField(
                      ValueKey('Address'),
                      signUpAddressController,
                      'Address',
                      TextInputType.streetAddress,
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: ObscureTextField(
                      ValueKey('password'),
                      signUpPasswordController,
                      'Password',
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _agree,
                        onChanged: (value) {
                          setState(() {
                            _agree = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth! * 0.01,
                      ),
                      Text(
                        'Agree terms and conditions',
                        style: TextStyles.h3,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  BasicButton(
                      buttonName: 'Ok',
                      onPressedFunction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Otp(signUpNumberController.text),
                          ),
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.08,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: BasicTextField(
                      ValueKey('Email'),
                      signInEmailController,
                      'Email',
                      TextInputType.emailAddress,
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.1,
                    width: SizeConfig.screenWidth! * 0.85,
                    child: ObscureTextField(
                      ValueKey('Email'),
                      signInPasswordController,
                      'Password',
                      (value) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'Forget Your Password?',
                        style: TextStyles.h3.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New on Match? ',
                        style: TextStyles.h1,
                      ),
                      Text(
                        ' Sign Up',
                        style: TextStyles.h1.copyWith(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  BasicButton(buttonName: 'Ok', onPressedFunction: () {}),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

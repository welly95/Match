import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import '../../widgets/buttons/basic_button.dart';

class Otp extends StatefulWidget {
  final phoneNumber;
  Otp(this.phoneNumber);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    final _otpController = TextEditingController();

    SizeConfig().init(context);

    String otp;
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
              Text(
                'Verfication Code',
                style: TextStyles.h2Bold,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              Text(
                'Please Enter the verfication code',
                style: TextStyles.h4,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.8,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    showCursor: true,
                    appContext: context,
                    controller: _otpController,
                    autoDisposeControllers: false,
                    cursorColor: Colors.grey[300],
                    pastedTextStyle: TextStyles.h2Bold,
                    length: 6,
                    textStyle: TextStyles.h3,
                    enabled: _isActive ? true : false,
                    animationType: AnimationType.fade,
                    enablePinAutofill: false,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.black,
                      activeColor: Colors.black,
                      selectedColor: Colors.black,
                      disabledColor: Colors.grey,
                      inactiveFillColor: Colors.grey,
                      inactiveColor: Colors.grey,
                    ),
                    backgroundColor: Theme.of(context).canvasColor.withOpacity(0.3),
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      otp = _otpController.text;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              Text(
                'Resend The Code',
                style: TextStyles.h4.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.22,
              ),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.85,
                height: SizeConfig.screenHeight! * 0.08,
                child: BasicButton(
                  buttonName: 'Ok',
                  onPressedFunction: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

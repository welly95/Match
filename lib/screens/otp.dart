import 'package:flutter/material.dart';
import 'package:modon_screens/widgets/buttons/styled_rounded_loading_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../constants/size_config.dart';
import '../../constants/styles.dart';

class Otp extends StatefulWidget {
  final phoneNumber;
  final void Function(String otp) signIn;
  final void Function(String phone) verifyPhoneNumber;

  Otp(this.phoneNumber, this.signIn, this.verifyPhoneNumber);

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

  TextEditingController _otpController = TextEditingController();
  RoundedLoadingButtonController _okButtonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String? otp;

    SizeConfig().init(context);
    print(widget.phoneNumber);
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
              Text(
                'Verfication Code',
                style: TextStyles.h2Bold,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.02,
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
                      setState(() {
                        otp = _otpController.text;
                        print(_otpController.text);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              TextButton(
                child: Text(
                  'Resend The Code',
                  style: TextStyles.h4.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(() {
                    otp = _otpController.text;
                  });
                  widget.verifyPhoneNumber(widget.phoneNumber);
                },
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.25,
              ),
              StyledRoundedLoadingButton(
                buttonController: _okButtonController,
                label: 'Ok',
                onPressed: () {
                  print(_otpController.text);
                  widget.signIn(_otpController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

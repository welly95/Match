import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/cart_screen.dart';
import 'package:modon_screens/screens/forget_password.dart';
import 'package:modon_screens/screens/otp.dart';
import 'package:modon_screens/widgets/basic_textfield.dart';
import 'package:modon_screens/widgets/buttons/styled_rounded_loading_button.dart';
import 'package:modon_screens/widgets/obscure_textfield.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> with SingleTickerProviderStateMixin {
  bool? _agree;
  @override
  void initState() {
    _agree = false;
    super.initState();
  }

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpNumberController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpAddressController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

  RoundedLoadingButtonController _signUpButtonController = RoundedLoadingButtonController();
  RoundedLoadingButtonController _signInButtonController = RoundedLoadingButtonController();

  final _form = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();

  int? userId;

  String? verificationId;

  Future<void> verifyPhoneNumber(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeAutoRetrievalTimeout: (String verId) {
        this.verificationId = verId;
      },
      codeSent: (String verId, int? resendCode) {
        this.verificationId = verId;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Otp(phone, signIn, verifyPhoneNumber),
          ),
        );
      },
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        print('${credential.toString()} let\'s do it');
      },
      verificationFailed: (FirebaseAuthException authException) {
        // _isLoading = true;
        print(authException.message);
      },
    );
  }

  Future<void> signIn(String otp) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      ))
          .then((_) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (ctx) => CartScreen(),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(SizeConfig.safeBlockHorizontal!, SizeConfig.safeBlockVertical! * 4),
              child: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyles.h1.copyWith(color: Colors.orange),
                tabs: <Widget>[
                  Tab(
                    child: FittedBox(
                      child: Text(
                        'Sign Up',
                        // style: TextStyles.h1,
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Text(
                        'Sign In',
                        // style: TextStyles.h1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _form,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.04,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.1,
                        width: SizeConfig.screenWidth! * 0.85,
                        child: BasicTextField(
                          ValueKey('Name'),
                          signUpNameController,
                          'Full Name',
                          TextInputType.name,
                          (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Full Name';
                            } else
                              return null;
                          },
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
                          (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Phone Number';
                            } else if (!value.startsWith('+20')) {
                              return 'Phone Number begins +20';
                            } else if (value.length < 12) {
                              return 'Enter valide number';
                            } else {
                              return null;
                            }
                          },
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
                          (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Email';
                            } else if (!value.contains('@')) {
                              return 'Enter a valide email';
                            } else if (!value.endsWith('.com')) {
                              return 'Enter a valide email';
                            } else {
                              return null;
                            }
                          },
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
                          (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Address';
                            } else {
                              return null;
                            }
                          },
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
                          (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Password';
                            } else if (value.length < 8) {
                              return 'Your Password must be more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.01,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _agree,
                            checkColor: Colors.black,
                            // focusColor: Colors.blue,
                            activeColor: Colors.transparent,
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
                      StyledRoundedLoadingButton(
                        label: 'Ok',
                        buttonController: _signUpButtonController,
                        onPressed: () async {
                          _form.currentState!.validate();

                          if (_form.currentState!.validate() && _agree == true) {
                            //ToDo: if user!=null go to checkout screen
                            verifyPhoneNumber(signUpNumberController.text).then((_) async {
                              try {
                                FirebaseFirestore.instance.collection('users').get().then((value) {
                                  setState(() {
                                    userId = value.size + 1;
                                  });
                                });
                              } on Exception catch (_) {
                                setState(() {
                                  userId = 1;
                                });
                              }
                              final userTokenId = await FirebaseMessaging.instance.getToken();
                              FirebaseFirestore.instance.collection('users').doc(userId.toString()).set({
                                'id': userId!,
                                'name': signUpNameController.text,
                                'mobile': signUpNumberController.text,
                                'email': signUpEmailController.text,
                                'address': signUpAddressController.text,
                                'password': signUpPasswordController.text,
                                'loginMethod': 1,
                                'status': 1,
                                'image': '',
                                'crDate': Timestamp.now(),
                                'token': userTokenId
                              });
                              FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: signUpEmailController.text,
                                password: signUpPasswordController.text,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Otp(signUpNumberController.text, signIn, verifyPhoneNumber),
                                ),
                              );
                            });
                          } else if (_agree == false) {
                            _signUpButtonController.reset();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please agree terms and conditions'),
                              ),
                            );
                          } else {
                            _signUpButtonController.reset();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: _form2,
                autovalidateMode: AutovalidateMode.disabled,
                child: ListView(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.08,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.1,
                      width: SizeConfig.screenWidth! * 0.85,
                      child: BasicTextField(
                        ValueKey('Email2'),
                        signInEmailController,
                        'Email',
                        TextInputType.emailAddress,
                        (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Email';
                          } else if (!value.contains('@')) {
                            return 'Enter a valide email';
                          }
                          if (!value.endsWith('.com')) {
                            return 'Enter a valide email';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.1,
                      width: SizeConfig.screenWidth! * 0.85,
                      child: ObscureTextField(
                        ValueKey('password2'),
                        signInPasswordController,
                        'Password',
                        (value) {
                          if (value!.isEmpty) {
                            return 'Enter Your Password';
                          } else if (value.length < 8) {
                            return 'Your Password must be more than 8 characters';
                          } else {
                            return null;
                          }
                        },
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
                        TextButton(
                          child: Text(
                            ' Sign Up',
                            style: TextStyles.h1.copyWith(color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(builder: (context) => CreateAccount()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    StyledRoundedLoadingButton(
                      label: 'Ok',
                      buttonController: _signInButtonController,
                      onPressed: () {
                        _form2.currentState!.validate();
                        if (_form2.currentState!.validate()) {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: signInEmailController.text,
                            password: signInPasswordController.text,
                          )
                              .then(
                            (value) async {
                              final snapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email', isEqualTo: signInEmailController.text)
                                  .get();
                              for (var queryDocumentSnapshot in snapshot.docs) {
                                Map<String, dynamic> data = queryDocumentSnapshot.data();
                                FirebaseAuth.instance.currentUser!.updateDisplayName(data['name']);
                                // FirebaseAuth.instance.currentUser!.updatePhoneNumber();
                              }
                              return Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CartScreen(),
                                ),
                              );
                            },
                          );
                        } else {
                          _signInButtonController.reset();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/cart_screen.dart';
import 'package:modon_screens/screens/create_account.dart';
import 'package:modon_screens/widgets/buttons/basic_button.dart';

class CheckOutScreen extends StatefulWidget {
  final totalPrice;

  CheckOutScreen(this.totalPrice);
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int? userId;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) async {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();
      for (var querySnapshotDocument in querySnapshot.docs) {
        Map<String, dynamic> data = querySnapshotDocument.data();
        userId = data['id'];
        print(userId);
      }
      // final querySnapshot2 = await FirebaseFirestore.instance
      //     .collection('order')
      //     .where('userId', isEqualTo: userId)
      //     .where('status', isEqualTo: 1)
      //     .get();
      // for (var querySnapshotDocument in querySnapshot2.docs) {
      //   // Map<String, dynamic> data = querySnapshotDocument.data();
      //   // totalPrice = double.parse(data['totalPrice']);
      //   docId = querySnapshotDocument.id;
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.add_shopping_cart_outlined,
                    size: 30,
                  ),
                  Text(
                    '   CheckOut',
                    style: TextStyles.h2,
                  ),
                ],
              ),
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orderItems')
                    .where('userId', isEqualTo: userId)
                    .where('isDeleted', isEqualTo: false)
                    .orderBy('id', descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Cart is Empty!',
                            style: TextStyles.h1.copyWith(
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                          ),
                          BasicButton(
                            buttonName: 'Start Shopping',
                            onPressedFunction: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateAccount(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );

                    //   return Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                  }
                  final cartItems = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: SizeConfig.screenWidth! * 0.0,
                      childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Center(
                          child: Stack(
                            children: [
                              FittedBox(child: Image.network(cartItems[index]['itemImage'])),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.8,
              height: SizeConfig.screenHeight! * 0.08,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  'Total: ${widget.totalPrice!.toStringAsFixed(2)} EGP',
                  style: TextStyles.h1,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.05,
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.08,
              width: SizeConfig.screenWidth! * 0.8,
              child: BasicButton(
                  buttonName: 'Confirm',
                  onPressedFunction: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      builder: (ctx) {
                        return Container(
                          height: SizeConfig.screenHeight! * 0.35,
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.02,
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 40,
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.05,
                              ),
                              Text(
                                'Your Order is Confirmed',
                                style: TextStyles.h1,
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.07,
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.08,
                                width: SizeConfig.screenWidth! * 0.8,
                                child: BasicButton(
                                  buttonName: 'ok',
                                  onPressedFunction: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(builder: (context) => CartScreen()));
                                  },
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight! * 0.03,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.02,
            )
          ],
        ),
      ),
    );
  }
}

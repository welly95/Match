import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/cart_screen.dart';
import 'package:modon_screens/widgets/buttons/styled_rounded_loading_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CheckOutScreen extends StatefulWidget {
  final totalPrice;

  CheckOutScreen(this.totalPrice);
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  RoundedLoadingButtonController _startShoppingController = RoundedLoadingButtonController();
  RoundedLoadingButtonController _confirmButtonController = RoundedLoadingButtonController();
  RoundedLoadingButtonController _okButtonController = RoundedLoadingButtonController();
  int? userId;
  var docId;
  final user = FirebaseAuth.instance.currentUser;
  int? status;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) async {
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();
        for (var querySnapshotDocument in querySnapshot.docs) {
          Map<String, dynamic> data = querySnapshotDocument.data();
          userId = data['id'];
          // print(userId);
        }
        final querySnapshot2 = await FirebaseFirestore.instance
            .collection('order')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 2)
            .get();
        for (var querySnapshotDocument2 in querySnapshot2.docs) {
          // Map<String, dynamic> data = querySnapshotDocument.data();
          // totalPrice = double.parse(data['totalPrice']);
          docId = querySnapshotDocument2.id;
          // print('docId======>' + docId);
        }

        final querySnapshot3 = await FirebaseFirestore.instance
            .collection('order')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 2)
            .get();
        for (var querySnapshotDocument3 in querySnapshot3.docs) {
          Map<String, dynamic> data = querySnapshotDocument3.data();
          setState(() {
            status = data['status'];
          });
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
      }
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
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
              indent: 15,
              endIndent: 15,
              thickness: 1,
              color: Colors.grey,
            ),
            (status == 2)
                ? Expanded(
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
                                StyledRoundedLoadingButton(
                                  buttonController: _startShoppingController,
                                  label: 'Start Shopping',
                                  onPressed: null,
                                  // () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CreateAccount(),
                                  //   ),
                                  // );
                                  // },
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
                            childAspectRatio:
                                MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
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
                  )
                : Expanded(
                    child: Center(
                    child: Text(
                      'Your Cart is Empty!',
                      style: TextStyles.h1.copyWith(
                        color: Colors.blueAccent,
                        fontSize: 18,
                      ),
                    ),
                  )),
            Container(
              width: SizeConfig.screenWidth! * 0.92,
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
            StyledRoundedLoadingButton(
                width: SizeConfig.screenWidth! * 0.92,
                buttonController: _confirmButtonController,
                label: 'Confirm',
                onPressed: () {
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
                              (status == 2) ? Icons.check : Icons.close,
                              color: Colors.black,
                              size: 40,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight! * 0.05,
                            ),
                            Text(
                              (status == 2) ? 'Your Order is Confirmed' : 'Add some Products to Cart!',
                              style: TextStyles.h1,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight! * 0.07,
                            ),
                            StyledRoundedLoadingButton(
                              buttonController: _okButtonController,
                              label: 'ok',
                              onPressed: () {
                                if (status == 2) {
                                  FirebaseFirestore.instance.collection('order').doc(docId).update({
                                    'totalPrice': widget.totalPrice,
                                    'status': 3,
                                  });
                                  Navigator.of(context).pushAndRemoveUntil(
                                      (MaterialPageRoute(
                                        builder: (context) => CartScreen(),
                                      )),
                                      (route) => false);
                                  _okButtonController.reset();
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      (MaterialPageRoute(
                                        builder: (context) => CartScreen(),
                                      )),
                                      (route) => false);
                                  _okButtonController.reset();
                                }
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight! * 0.03,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  _confirmButtonController.reset();
                }),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.02,
            )
          ],
        ),
      ),
    );
  }
}

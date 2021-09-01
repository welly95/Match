import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/checkout_screen.dart';
import 'package:modon_screens/screens/create_account.dart';
import 'package:modon_screens/widgets/buttons/styled_rounded_loading_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  RoundedLoadingButtonController _startShoppingController = RoundedLoadingButtonController();
  RoundedLoadingButtonController _checkOutController = RoundedLoadingButtonController();

  final user = FirebaseAuth.instance.currentUser;
  int? userId;
  int? status;
  int? status2;
  var docId;
  double? totalPrice = 0;
  List _pricesList = [];
  bool? _startFetching;

  @override
  void initState() {
    setState(() {
      _startFetching = false;
    });
    Future.delayed(Duration(seconds: 0)).then(
      (value) async {
        if (user != null) {
          final querySnapshot =
              await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user!.email).get();
          for (var querySnapshotDocument in querySnapshot.docs) {
            Map<String, dynamic> data = querySnapshotDocument.data();
            userId = data['id'];
            print('userId=======>' + (userId).toString());
            setState(() {
              _startFetching = true;
            });
          }
          final querySnapshot2 = await FirebaseFirestore.instance
              .collection('order')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 1)
              .get();
          for (var querySnapshotDocument2 in querySnapshot2.docs) {
            docId = querySnapshotDocument2.id;
            print('docId======>' + docId);
          }
          final querySnapshot3 = await FirebaseFirestore.instance
              .collection('order')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 1)
              .get();
          for (var querySnapshotDocument3 in querySnapshot3.docs) {
            Map<String, dynamic> data = querySnapshotDocument3.data();
            setState(() {
              status = data['status'];
            });
            // print('status=======>' + status.toString());
          }
          final querySnapshot4 = await FirebaseFirestore.instance
              .collection('order')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 2)
              .get();
          for (var querySnapshotDocument4 in querySnapshot4.docs) {
            Map<String, dynamic> data = querySnapshotDocument4.data();
            setState(() {
              status2 = data['status'];
            });
            // print('status=======>' + status.toString());
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userNumber = FirebaseAuth.instance.currentUser!;
    // FirebaseAuth.instance.signOut();
    SizeConfig().init(context);
    print(user.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                  Text(
                    '   My Cart',
                    style: TextStyles.h2,
                  ),
                  (user == null)
                      ? Container()
                      : Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  FirebaseAuth.instance.signOut().then((_) => Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(builder: (context) => CartScreen())));
                                },
                                child: Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
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
            (_startFetching!)
                ? (status == 1 || status2 == 2)
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orderItems')
                              .where('userId', isEqualTo: userId)
                              .orderBy('id', descending: false)
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> cartSnapshot) {
                            if (FirebaseAuth.instance.currentUser == null) {
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
                                    SizedBox(
                                      height: SizeConfig.screenHeight! * 0.04,
                                    ),
                                    StyledRoundedLoadingButton(
                                      label: 'Start Shopping',
                                      buttonController: _startShoppingController,
                                      width: SizeConfig.screenWidth! * 0.75,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CreateAccount(),
                                          ),
                                        );
                                        _startShoppingController.reset();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (cartSnapshot.data == null) {
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
                                    SizedBox(
                                      height: SizeConfig.screenHeight! * 0.04,
                                    ),
                                    StyledRoundedLoadingButton(
                                      label: 'Start Shopping',
                                      buttonController: _startShoppingController,
                                      width: SizeConfig.screenWidth! * 0.75,
                                      onPressed: null,
                                      // (){
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
                            } else if (cartSnapshot.data!.docs.any((element) => element['isDeleted'] == true)) {
                              print('isDeleted==========>' + cartSnapshot.data!.docs.toString());
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
                                    SizedBox(
                                      height: SizeConfig.screenHeight! * 0.04,
                                    ),
                                    StyledRoundedLoadingButton(
                                      label: 'Start Shopping',
                                      buttonController: _startShoppingController,
                                      width: SizeConfig.screenWidth! * 0.75,
                                      onPressed: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) => CreateAccount(),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }

                            final cartItems = cartSnapshot.data!.docs;
                            _pricesList.clear();
                            totalPrice = 0;
                            return ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                var price = cartItems[index]['price'];
                                _pricesList.add(price);
                                if (index + 1 == cartItems.length) {
                                  // totalPrice = 0;
                                  for (int i = 0; i < _pricesList.length; i++) {
                                    totalPrice = totalPrice! + double.parse(_pricesList[i]);
                                    // print(totalPrice.toString());
                                  }
                                  return Column(
                                    children: [
                                      Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: SizeConfig.screenHeight! * 0.19,
                                                width: SizeConfig.screenWidth! * 0.35,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: Colors.grey),
                                                ),
                                                child: Image.network(
                                                  cartItems[index]['itemImage'].toString(),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Container(
                                                height: SizeConfig.screenHeight! * 0.18,
                                                margin: EdgeInsets.only(left: 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cartItems[index]['name'],
                                                      style: TextStyles.h4,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig.screenHeight! * 0.015,
                                                    ),
                                                    Text(
                                                      cartItems[index]['initPrice'] + ' EGP',
                                                      style: TextStyles.h4,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig.screenHeight! * 0.015,
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      width: 15,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig.screenHeight! * 0.015,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig.screenHeight! * 0.048,
                                                      width: SizeConfig.screenWidth! * 0.5,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (cartItems[index]['count'] == 1) {
                                                                    return;
                                                                  }
                                                                  FirebaseFirestore.instance
                                                                      .collection('orderItems')
                                                                      .doc(cartItems[index].id)
                                                                      .update({
                                                                    'count': cartItems[index]['count'] - 1,
                                                                  }).then(
                                                                    (_) {
                                                                      return FirebaseFirestore.instance
                                                                          .collection('orderItems')
                                                                          .doc(cartItems[index].id)
                                                                          .update({
                                                                        'price': ((cartItems[index]['count'] - 1) *
                                                                                double.parse(
                                                                                    cartItems[index]['initPrice']))
                                                                            .toStringAsFixed(2)
                                                                            .toString(),
                                                                      }).then(
                                                                        (_) => FirebaseFirestore.instance
                                                                            .collection('order')
                                                                            .doc(docId)
                                                                            .update(
                                                                          {
                                                                            'totalPrice': totalPrice,
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.all(2),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(100),
                                                                      border:
                                                                          Border.all(width: 1, color: Colors.black)),
                                                                  child: Icon(
                                                                    Icons.remove,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                cartItems[index]['count'].toString(),
                                                                style: TextStyles.h4,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  FirebaseFirestore.instance
                                                                      .collection('orderItems')
                                                                      .doc(cartItems[index].id)
                                                                      .update({
                                                                    'count': cartItems[index]['count'] + 1,
                                                                  }).then((_) {
                                                                    return FirebaseFirestore.instance
                                                                        .collection('orderItems')
                                                                        .doc(cartItems[index].id)
                                                                        .update({
                                                                      'price': ((cartItems[index]['count'] + 1) *
                                                                              double.parse(
                                                                                  cartItems[index]['initPrice']))
                                                                          .toStringAsFixed(2)
                                                                          .toString(),
                                                                    }).then((_) => FirebaseFirestore.instance
                                                                                .collection('order')
                                                                                .doc(docId)
                                                                                .update({
                                                                              'totalPrice': totalPrice,
                                                                            }));
                                                                  });
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.all(2),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    border: Border.all(width: 1, color: Colors.black),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              FirebaseFirestore.instance
                                                                  .collection('orderItems')
                                                                  .doc(cartItems[index].id)
                                                                  .update({
                                                                'isDeleted': true,
                                                              });
                                                            },
                                                            icon: Icon(Icons.delete_outline),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.screenHeight! * 0.02,
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth! * 0.92,
                                        height: SizeConfig.screenHeight! * 0.08,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Total: ${totalPrice!.toStringAsFixed(2)} EGP',
                                            style: TextStyles.h1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: SizeConfig.screenHeight! * 0.19,
                                              width: SizeConfig.screenWidth! * 0.35,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: Colors.grey),
                                              ),
                                              child: Image.network(
                                                cartItems[index]['itemImage'].toString(),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              height: SizeConfig.screenHeight! * 0.18,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cartItems[index]['name'],
                                                    style: TextStyles.h4,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight! * 0.015,
                                                  ),
                                                  Text(
                                                    cartItems[index]['initPrice'] + ' EGP',
                                                    style: TextStyles.h4,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight! * 0.015,
                                                  ),
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight! * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.screenHeight! * 0.048,
                                                    width: SizeConfig.screenWidth! * 0.5,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if (cartItems[index]['count'] == 1) {
                                                                  return;
                                                                }
                                                                FirebaseFirestore.instance
                                                                    .collection('orderItems')
                                                                    .doc(cartItems[index].id)
                                                                    .update({
                                                                  'count': cartItems[index]['count'] - 1,
                                                                }).then(
                                                                  (_) {
                                                                    return FirebaseFirestore.instance
                                                                        .collection('orderItems')
                                                                        .doc(cartItems[index].id)
                                                                        .update({
                                                                      'price': ((cartItems[index]['count'] - 1) *
                                                                              double.parse(
                                                                                  cartItems[index]['initPrice']))
                                                                          .toStringAsFixed(2)
                                                                          .toString(),
                                                                    }).then(
                                                                      (_) => FirebaseFirestore.instance
                                                                          .collection('order')
                                                                          .doc(docId)
                                                                          .update(
                                                                        {
                                                                          'totalPrice': totalPrice,
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    border: Border.all(width: 1, color: Colors.black)),
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              cartItems[index]['count'].toString(),
                                                              style: TextStyles.h4,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                FirebaseFirestore.instance
                                                                    .collection('orderItems')
                                                                    .doc(cartItems[index].id)
                                                                    .update({
                                                                  'count': cartItems[index]['count'] + 1,
                                                                }).then((_) {
                                                                  return FirebaseFirestore.instance
                                                                      .collection('orderItems')
                                                                      .doc(cartItems[index].id)
                                                                      .update({
                                                                    'price': ((cartItems[index]['count'] + 1) *
                                                                            double.parse(cartItems[index]['initPrice']))
                                                                        .toStringAsFixed(2)
                                                                        .toString(),
                                                                  }).then((_) => FirebaseFirestore.instance
                                                                              .collection('order')
                                                                              .doc(docId)
                                                                              .update({
                                                                            'totalPrice': totalPrice,
                                                                          }));
                                                                });
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  border: Border.all(width: 1, color: Colors.black),
                                                                ),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            FirebaseFirestore.instance
                                                                .collection('orderItems')
                                                                .doc(cartItems[index].id)
                                                                .update({
                                                              'isDeleted': true,
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete_outline),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      indent: 15,
                                      endIndent: 15,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight! * 0.02,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
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
                            SizedBox(
                              height: SizeConfig.screenHeight! * 0.04,
                            ),
                            StyledRoundedLoadingButton(
                              label: 'Start Shopping',
                              buttonController: _startShoppingController,
                              width: SizeConfig.screenWidth! * 0.75,
                              onPressed: () {
                                _startShoppingController.reset();
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => CreateAccount(),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ))
                : Expanded(
                    child: Center(
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
                        SizedBox(
                          height: SizeConfig.screenHeight! * 0.04,
                        ),
                        StyledRoundedLoadingButton(
                          label: 'Start Shopping',
                          buttonController: _startShoppingController,
                          width: SizeConfig.screenWidth! * 0.75,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateAccount(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.08,
                    width: SizeConfig.screenWidth! * 0.83,
                    child: StyledRoundedLoadingButton(
                      label: 'Check Out',
                      buttonController: _checkOutController,
                      onPressed: () {
                        if (user != null && (status == 1 || status2 == 2)) {
                          FirebaseFirestore.instance.collection('order').doc(docId).update({
                            'totalPrice': totalPrice,
                            'status': 2,
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckOutScreen(totalPrice),
                            ),
                          );
                        } else {
                          _checkOutController.reset();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckOutScreen(0.0),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth! * 0.008,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.075,
                    width: SizeConfig.screenWidth! * 0.15,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        launch('tel:+201142952828');
                        // FirebaseAuth.instance.signOut();
                      },
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

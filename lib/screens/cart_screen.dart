import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/checkout_screen.dart';
import 'package:modon_screens/screens/create_account.dart';
import 'package:modon_screens/widgets/buttons/basic_button.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final user = FirebaseAuth.instance.currentUser;
  int? userId;
  var docId;
  double? totalPrice = 0;
  List _pricesList = [];

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
      final querySnapshot2 = await FirebaseFirestore.instance
          .collection('order')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 1)
          .get();
      for (var querySnapshotDocument in querySnapshot2.docs) {
        // Map<String, dynamic> data = querySnapshotDocument.data();
        // totalPrice = double.parse(data['totalPrice']);
        docId = querySnapshotDocument.id;
      }
    });

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
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> cartSnapshot) {
                  if (cartSnapshot.data == null || FirebaseAuth.instance.currentUser == null) {
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
                          print(totalPrice.toString());
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
                                      height: SizeConfig.screenHeight! * 0.12,
                                      width: SizeConfig.screenWidth! * 0.35,
                                      child: Image.network(
                                        cartItems[index]['itemImage'].toString(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: SizeConfig.screenHeight! * 0.12,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItems[index]['name'],
                                            style: TextStyles.h4,
                                          ),
                                          Text(
                                            price + ' EGP',
                                            style: TextStyles.h4,
                                          ),
                                          Container(
                                            height: 15,
                                            width: 15,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            height: 22,
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
                                                                      double.parse(cartItems[index]['initPrice']))
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
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 0.0,
                                                          bottom: 8.0,
                                                          right: 8.0,
                                                          left: 0.0,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      cartItems[index]['count'].toString(),
                                                      style: TextStyles.h2,
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
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 0.0,
                                                          bottom: 8.0,
                                                          left: 8.0,
                                                          right: 0.0,
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 30,
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
                              indent: 25,
                              endIndent: 25,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight! * 0.03,
                            ),
                            Container(
                              width: SizeConfig.screenWidth! * 0.8,
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
                                    height: SizeConfig.screenHeight! * 0.12,
                                    width: SizeConfig.screenWidth! * 0.35,
                                    child: Image.network(
                                      cartItems[index]['itemImage'].toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: SizeConfig.screenHeight! * 0.12,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItems[index]['name'],
                                          style: TextStyles.h4,
                                        ),
                                        Text(
                                          price + ' EGP',
                                          style: TextStyles.h4,
                                        ),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          height: 22,
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
                                                                    double.parse(cartItems[index]['initPrice']))
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
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                        top: 0.0,
                                                        bottom: 8.0,
                                                        right: 8.0,
                                                        left: 0.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    cartItems[index]['count'].toString(),
                                                    style: TextStyles.h2,
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
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                        top: 0.0,
                                                        bottom: 8.0,
                                                        left: 8.0,
                                                        right: 0.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 30,
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
                            indent: 25,
                            endIndent: 25,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
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
                    child: BasicButton(
                      buttonName: 'CheckOut',
                      onPressedFunction: () {
                        if (user != null) {
                          FirebaseFirestore.instance.collection('order').doc(docId).update({
                            'totalPrice': totalPrice,
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckOutScreen(totalPrice),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateAccount(),
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
                    height: SizeConfig.screenHeight! * 0.08,
                    width: SizeConfig.screenWidth! * 0.15,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
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

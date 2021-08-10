import 'package:flutter/material.dart';
import 'package:modon_screens/constants/size_config.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:modon_screens/screens/create_account.dart';
import 'package:modon_screens/widgets/buttons/basic_button.dart';

class CartScreen extends StatelessWidget {
  get i => null;

  @override
  Widget build(BuildContext context) {
    final listOfCart = [
      {
        'name': 'Lounge',
        'image': 'assets/images/furniture1.png',
        'price': '1500',
        'color': '0xFFA52A2A',
        'quantity': 1,
      },
      {
        'name': 'Sofa',
        'image': 'assets/images/furniture2.jpg',
        'price': '3500',
        'color': '0xFF808080',
        'quantity': 1,
      },
      {
        'name': 'Metal Lounge',
        'image': 'assets/images/furniture3.png',
        'price': '2000',
        'color': '0xFFFF0000',
        'quantity': 1,
      },
    ];

    final listOfPrice = [];
    SizeConfig().init(context);

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
              thickness: 2,
              color: Colors.black,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listOfCart.length,
                itemBuilder: (ctx, i) {
                  listOfPrice.add(listOfCart[i]['name']);
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
                                child: Image.asset(
                                  listOfCart[i]['image'].toString(),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 1,
                                height: SizeConfig.screenHeight! * 0.12,
                                color: Colors.black,
                              ),
                              Container(
                                height: SizeConfig.screenHeight! * 0.12,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listOfCart[i]['name'].toString(),
                                      style: TextStyles.h4,
                                    ),
                                    Text(
                                      listOfCart[i]['price'].toString() + ' EGP',
                                      style: TextStyles.h4,
                                    ),
                                    Container(
                                      height: 15,
                                      width: 15,
                                      color: Color(
                                        int.parse(
                                          listOfCart[i]['color'].toString(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                iconSize: 20,
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                ),
                                              ),
                                              Text(
                                                listOfCart[i]['quantity'].toString(),
                                                style: TextStyles.h2,
                                              ),
                                              IconButton(
                                                iconSize: 20,
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              listOfPrice.removeWhere(
                                                  (element) => element == int.parse(listOfCart[i]['price'].toString()));
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
                        color: Colors.black,
                      ),
                    ],
                  );
                },
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(0),
            //     ),
            //     backgroundColor: Colors.white,
            //   ),
            //   onPressed: () {},
            //   child: SizedBox(
            //     height: SizeConfig.screenWidth! * 0.15,
            //     width: SizeConfig.screenWidth! * 0.85,
            //     child: Text(
            //       'Total: ${listOfPrice.toString()}',
            //       style: TextStyles.h2,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.08,
                  width: SizeConfig.screenWidth! * 0.75,
                  child: BasicButton(
                    buttonName: 'CheckOut',
                    onPressedFunction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateAccount(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.08,
                  width: SizeConfig.screenWidth! * 0.2,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'cart.dart';
import 'signin.dart';
import 'signup.dart';
import 'edititems.dart';
import 'orders.dart';
import 'register.dart';
import 'items.dart';
import 'package:kirana/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:kirana/models/items.dart';
import 'package:kirana/models/cart.dart';

import 'package:kirana/models/orderslist.dart';

import 'package:kirana/models/startup.dart';


class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool is_signed_in;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ItemsModel(),
          ),
          ChangeNotifierProxyProvider<ItemsModel, CartModel>(
            create: (BuildContext context) => CartModel(),
            update: (context, items, cart) {
              cart.catalog = items;
              return cart;
            },
          ),
          ChangeNotifierProvider(
            create: (context) => OrdersListModel(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              "/signin": (context) => SignInPage(),
              "/signup":(context) => SignUpPage()
            },
            home: Scaffold(
                appBar: AppBar(
                  title: Text('Home page'),
                  centerTitle: true,
                ),
                body: ListView(
                  children: <Widget>[
                    button(SignInPage()),
                    button(SignUpPage()),
                    button(CartPage()),
                    button(EditItemsPage()),
                    button(OrdersPage()),
                    button(Register()),
                    button(ItemsPage())
                  ],
                ))));
  }
}

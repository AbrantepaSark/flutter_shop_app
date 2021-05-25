import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/Products.dart';
import './providers/Cart.dart';
import './providers/Order.dart';
import './providers/Auth.dart';

import './screens/product_details_screen.dart';
import './screens/products_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop Project',
            theme: ThemeData(
                primarySwatch: Colors.pink,
                accentColor: Colors.deepOrange,
                fontFamily: 'SourceSansPro'),
            initialRoute: auth.isAuth ? '/' : '/auth',
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductsScreen.routeName: (ctx) => ProductsScreen(),
              ProductDetails.routeName: (ctx) => ProductDetails(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}

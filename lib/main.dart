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
import './screens/splash_screen.dart';

void main() {
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
          ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (ctx, auth, data) =>
                Products(auth.token, data == null ? [] : data.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, auth, data) =>
                Orders(auth.token, data == null ? [] : data.orders),
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
            home: auth.isAuth
                ? ProductsScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, result) =>
                        result.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
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

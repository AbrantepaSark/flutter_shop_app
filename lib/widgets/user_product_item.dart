import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Products.dart';

import '../screens/edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageURL;
  UserProductItem(this.id, this.title, this.imageURL);

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  var _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(widget.imageURL),
        ),
        title: Text(widget.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName,
                        arguments: widget.id);
                  }),
              _isDeleting
                  ? CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () async {
                        setState(() {
                          _isDeleting = true;
                        });
                        try {
                          await Provider.of<Products>(context, listen: false)
                              .deleteProduct(widget.id);

                          setState(() {
                            _isDeleting = false;
                          });
                          //Show snakbar on adding to cart
                          scaffold.hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text('Item deleted successful.'),
                            ),
                          );
                        } catch (e) {
                          //Show snakbar on adding to cart
                          scaffold.hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text(e),
                            ),
                          );
                        }
                      }),
            ],
          ),
        ));
  }
}

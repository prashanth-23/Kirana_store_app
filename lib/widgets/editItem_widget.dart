import 'package:flutter/material.dart';
import 'package:kirana/pages/editItem.dart';
import 'package:provider/provider.dart';
import 'package:kirana/models/items.dart';
import 'package:kirana/models/Item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';

class EditItemTile extends StatefulWidget {
  final id;

  EditItemTile(this.id);

  @override
  _EditItemTileState createState() => _EditItemTileState();
}

class _EditItemTileState extends State<EditItemTile> {
  @override
  Widget build(BuildContext context) {
    var catalog = Provider.of<ItemsModel>(context, listen: false);
    Item item = catalog.getItemById(widget.id);
    return Column(children: [_Tile(item), Divider()]);
  }

  Widget _Tile(Item item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: item.imageurl,
            width: MediaQuery.of(context).size.width / 4,
            height: 120,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(3),
                    width: (3 * MediaQuery.of(context).size.width) / 4 - 50,
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 18),
                      softWrap: true,
                      maxLines: 2,
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("Price"),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          (item.price).toString(),
                          style:
                              TextStyle(fontSize: 20, color: Colors.green[800]),
                        )),
                  ],
                ),
                Consumer<ItemsModel>(
                  builder: (context, catalog, child) =>
                      buttonEdit(catalog, item),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  buttonEdit(catalog, item) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 20,
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Edit".toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.amber[700],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                editItemPage(catalog.getItemById(item.id))));
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.delete,color: Colors.red,size: 30,),
                      onPressed: () {
                        _showMyDialog(catalog, item);

                      },
                    ),
                  ),
                ),
              ],
            )));
  }
  Future<void> _showMyDialog(catalog,item) async {
    return showDialog<void>(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really Want to remove'),
                SizedBox(height: 10,),
                Text("${item.name}",style: TextStyle(color: Colors.red[800],fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No',style: TextStyle(fontSize: 25),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/3,0,0,0),
              child: FlatButton(
                child: Text('Yes',style: TextStyle(fontSize: 25)),
                onPressed: () {
                  catalog.remove(item);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
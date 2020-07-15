import 'package:flutter/material.dart';
import 'package:kirana/models/items.dart';
import 'package:kirana/pages/items.dart';
import 'package:kirana/widgets/ImagePicker.dart';
import 'package:kirana/widgets/TextFieldWidget.dart';
import 'package:kirana/models/Item.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditItemsPageForm extends StatefulWidget {
  @override
  _EditItemsPageFormState createState() => _EditItemsPageFormState();
}

class _EditItemsPageFormState extends State<EditItemsPageForm> {
  final name = 'edititems';
  final _formKey = GlobalKey<FormState>();
  String itemname;
  String description;
  double price;
  double originalPrice;
  String imageurl = '';
  File itemimage;
  int id;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final mrpController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceController.dispose();
    mrpController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImage() async {
    StorageReference reference = _storage.ref().child('images/');
    StorageUploadTask uploadTask = reference.child("${nameController.text}${DateTime.now().millisecondsSinceEpoch}").putFile(itemimage);
    if (uploadTask.isSuccessful || uploadTask.isComplete) {
      final String url = await reference.getDownloadURL();
      print("The download URL is " + url);
      setState(() {
        imageurl=url;
      });
    } else if (uploadTask.isInProgress) {
      uploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      imageurl = await storageTaskSnapshot.ref.getDownloadURL();


      //Here you can get the download URL when the task has been completed.
      print("Download URL " + imageurl.toString());
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Error uploading pic"),
        backgroundColor: Colors.red,
      ));
      return imageurl;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        TextFieldWidgetWithValidation('Name', nameController),
        NumberFieldWidgetWithValidation('price', priceController),
        NumberFieldWidgetWithValidation('original price', mrpController),
        MultilineTextWidgetWithValidation('description', descriptionController),
        ItemImagePicker(notifyParent: setUrl),
        Container(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: RaisedButton(
                  child: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(color: Colors.white, letterSpacing: 1),
                  ),
                  color: Colors.green[700],
                  onPressed: () async{
                    await uploadImage();
                    if (_formKey.currentState.validate()) {
                      itemname = nameController.text;
                      price = double.parse(priceController.text);
                      originalPrice = double.parse(mrpController.text);
                      description = descriptionController.text;
                      id = new DateTime.now().millisecondsSinceEpoch;
                      if (imageurl == "") {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("select an image")));
                      } else {
                        _additem_to_container();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemsPage()));
                      }
                    }
                  })),
        )
      ]),
    );
  }

  void setUrl(File image) {
    setState(() {
      itemimage = image;
      print("image setted");
      if(itemimage==null){
        print("done");
      }
    });
  }

  void _additem_to_container() {
    var catalog = Provider.of<ItemsModel>(context, listen: false);
    catalog
        .add(Item(itemname, price, description, originalPrice, imageurl, id));
  }
}

class EditItemsPage extends StatelessWidget {
  final name = "edit items";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit items",
        ),
      ),
      body: EditItemsPageForm(),
    );
  }
}

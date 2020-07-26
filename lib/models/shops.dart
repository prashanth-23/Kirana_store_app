import 'package:kirana/models/items.dart';
import 'package:kirana/models/shop.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kirana/models/Item.dart';

class Shops extends ChangeNotifier {
  List<Shop> shops = [];
  ItemsModel items = ItemsModel();
  String selectedshopid;
  Shops();
  void fromf() async {
    shops = [];
    QuerySnapshot snapshot =
        await Firestore.instance.collection('shops').getDocuments();
    snapshot.documents.forEach((element) {
      shops.add(Shop.fromJson(element.data));
      notifyListeners();
    });
  }

  Shop getShopById(String id) {
    int index = shops.indexWhere((element) => element.getHashCode() == id);
    return shops[index];
  }

  Future<Shop> getShopByuserId(String id) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('shops').document(id).get();
    return Shop.fromJson(snapshot.data);
  }

  void add() {
    fromf();
    notifyListeners();
  }

  void setItems(shopownerid) {
    print(shops);
    selectedshopid = shopownerid;
    print(shops);
    writeshoptoSF(shopownerid);
    notifyListeners();
  }

  void writeshoptoSF(String shopid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("shopid", shopid);
  }

  Future<bool> getfromSF() async {
    if (selectedshopid != null) {
      return true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String shopid = prefs.getString("shopid");
      notifyListeners();
      if (shopid != null) {
        selectedshopid = shopid;
        notifyListeners();
        print("reading $shopid");
        return true;
      } else {
        return false;
      }
    }
  }

  Future<Item> getItem(String shopid, String menuitemid) async {
    try {
      DocumentSnapshot s = await Firestore.instance
          .collection('shops')
          .document(shopid)
          .collection('items')
          .document(menuitemid)
          .get();
      if (s.exists) {
        return Item.fromJson(s.data);
      } else {
        return null;
      }
    } catch (e) {}
  }
}

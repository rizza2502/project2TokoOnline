import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart.dart';
import 'package:flutter_application_1/services/db_helper.dart';

class CartProvider extends ChangeNotifier {
  int counter = 0;
  var dBHelper = DBHelper();
  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await DBHelper().getCartList();
    notifyListeners();
    return cart;
  }

  void addCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  void removeCounter() {
    counter--;
    counter = cart.length;
    notifyListeners();
  }

  void getCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  void addQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity = cart[index].quantity! + 1;
    await dBHelper.updateQuantity(
      cart[index].id.toString(),
      cart[index].quantity,
    );
    notifyListeners();
  }

  void deleteQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!;
    if (currentQuantity > 1) {
      cart[index].quantity = currentQuantity - 1;
      await dBHelper.updateQuantity(
        cart[index].id.toString(),
        cart[index].quantity,
      );
    }
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    notifyListeners();
  }

  // Total harga semua item di cart
  int get totalHarga {
    return cart.fold(
      0,
      (sum, item) => sum + ((item.harga ?? 0) * (item.quantity ?? 1)),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:chat_app/helpers/AppConfig.dart';
import 'package:chat_app/helpers/common.dart';
import 'package:chat_app/models/JSONResponseModels.dart';
import 'package:chat_app/models/cart_item.dart';
import 'package:chat_app/models/order.dart';
import 'package:chat_app/models/product.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/services/order.dart';
import 'package:chat_app/services/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;

 enum  Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser  _user    ;
   Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();

  UserModel _userModel;

//  getter
  UserModel get fuserModel => _userModel;

  Status get status => _status;

  FirebaseUser get user => _user;

  // public variables
  List<OrderModel> orders = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }


 Future<http.Response> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      var response = await http.post(
        AppConfig.LOGIN_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Email': email,
          'Password': password,

        }),
      );

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
    //  print(e.toString());

      return e;

    }
  }

  Future<http.Response> signUp(String name, String email, String password) async {

    try {
      _status = Status.Authenticating;
      notifyListeners();
      var response = await http.post(
        AppConfig.REGISTER_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Email': email,
          'Password': password,
          'ConfirmPassword': password,
        }),
      );

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');
      return response;

   } catch (Exception ) {
      _status = Status.Unauthenticated;
      notifyListeners();
      //print(Exception);
      return Exception;
    }
  }

  Future signOut(BuildContext context) async {
    changeScreenReplacement(
        context, Login());
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart(
      {Products product, String size, String color}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.productName,
        "image": product.imageUrl,
        "productId": product.productName,
        "price": product.unitPrice,
        "size": size,
        "color": color
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }




  Future<void> reloadUserModel() async {
  /*  _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();*/
  }
}

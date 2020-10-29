import 'package:chat_app/helpers/AppConfig.dart';
import 'package:chat_app/models/JSONResponseModels.dart';
import 'package:chat_app/models/product.dart';
import 'package:chat_app/provider/user.dart';
import 'package:chat_app/services/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();

  // List<ProductModel> products = [];
  List<Products> products = [];
  List<Products> productsSearched = [];

  ProductProvider.initialize() {
    loadProducts();
  }

 loadProducts() async {
    AppConfig.getProducts();
    AppConfig.getCartProducts();
    await AppConfig.getOrders();
    products = AppConfig.productsObjs;
   // notifyListeners();
  }

  Future search({String productName}) async {
  /*  productsSearched =
        await _productServices.searchProducts(productName: productName);*/
    notifyListeners();
  }
}

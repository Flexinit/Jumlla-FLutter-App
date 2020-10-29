import 'dart:convert';

import 'package:chat_app/models/JSONResponseModels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  //static const String MAIN_URL = "http://192.168.43.126:81/";

  static const String MAIN_URL = "http://144.91.82.244:808/";
  //static const String MAIN_URL = "http://192.168.100.19:81/";
  static const String LOGIN_URL = MAIN_URL + "Account/SignIn";
  static const String REGISTER_URL = MAIN_URL + "Account/SignUp";
  static const String LOAD_PRODUCTS = MAIN_URL + "Account/GetProductsGoods";
  static const String LOAD_CART_PRODUCTS = MAIN_URL + "Account/GetCartProducts";
  static const String SEARCH_PRODUCTS =
      MAIN_URL + "Account/SearchProductsGoods";
  static const String ADD_PRODUCT_CATEGORY =
      MAIN_URL + "ProductCategories/AddProductCategory";
  static const String ADD_PRODUCT = MAIN_URL + "AllProducts/AddProduct";
  static const String ADD_PRODUCT_BRAND =
      MAIN_URL + "ProductCategories/AddProductBrand";
  static const String GET_PRODUCT_CATEGORY =
      MAIN_URL + "Account/GetProductCategory";
  static const String GET_PRODUCT_BRAND = MAIN_URL + "Account/GetProductBrand";
  static const String ADD_ITEM_TO_CART = MAIN_URL + "Carts/AddToCart";
  static const String REMOVE_ITEM_FROM_CART =
      MAIN_URL + "Carts/RemoveProductFromCart";
  static const String CREATE_ORDER = MAIN_URL + "Orders/CreateOrder";
  static const String GET_ORDERS = MAIN_URL + "Account/GetOrders";

  static String username;
  static String password;
  static List<Products> productsObjs = [];
  static List<Products> searchedProductsObjs = [];
  static List<CartItems> cartProducts = [];
  static List<Orders> ordersList = [];
  static List<String> colors = [];
  static List<String> sizes = [];
  static List<String> cartProductNames = [];
  static String cartProductNamesStr;

  static var totalCartPrice = 0;

  void saveToSharedPrefs(String _key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$_key', value);
  }

  static Future<String> retrieveFromSharedPrefs(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('$_key') ?? "start";
    return value;
  }

  void deleteFromSharedPrefs(String _key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('$_key');
  }

  static Future<http.Response> getProducts() async {
    //  try {

    String username = await retrieveFromSharedPrefs('email');
    String password = await retrieveFromSharedPrefs('pass');
    var response = await http.post(
      AppConfig.LOAD_PRODUCTS,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': username,
        'Password': password,
      }),
    );
    print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
    print('----DEBUG---Server Response: ' + '${response.body}');

    var productsObjsJson = jsonDecode(response.body)['Message'] as List;
    productsObjs =
        productsObjsJson.map((tagJson) => Products.fromJson(tagJson)).toList();

    colors = productsObjs[0].colors.split(",");
    sizes = productsObjs[0].sizes.split(",");
    print('Parsed Categories:  ${productsObjs[0].productName}');


    return response;
    /* } catch (e) {

     // return e;
    }*/
  }

  static Future<http.Response> getSearchedProducts(
      {String searchString}) async {
    //  try {
    String pattern = searchString;

    String username = await retrieveFromSharedPrefs('email');
    String password = await retrieveFromSharedPrefs('pass');
    var response = await http.post(
      AppConfig.SEARCH_PRODUCTS,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': username,
        'Password': password,
        'productName': pattern,
      }),
    );

    var productsObjsJson = jsonDecode(response.body)['Message'] as List;
    searchedProductsObjs =
        productsObjsJson.map((tagJson) => Products.fromJson(tagJson)).toList();

    // colors = searchedProductsObjs[0].colors.split(",");
    // sizes = searchedProductsObjs[0].sizes.split(",");
    print('SEARCHED Categories:  ${searchedProductsObjs[0].productName}');

    print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
    print('----DEBUG---Server Response: ' + '${response.body}');

    return response;
    /* } catch (e) {

     // return e;
    }*/
  }

  static Future<http.Response> getCartProducts() async {
    String username = await retrieveFromSharedPrefs('email');
    String password = await retrieveFromSharedPrefs('pass');
    var response = await http.post(
      AppConfig.LOAD_CART_PRODUCTS,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': username,
        'Password': password,
      }),
    );

    print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
    print('----DEBUG---Server Response: ' + '${response.body}');

    var productsObjsJson = jsonDecode(response.body)['Message'] as List;
    cartProducts =
        productsObjsJson.map((tagJson) => CartItems.fromJson(tagJson)).toList();

    if (cartProducts.length !=0) {
      totalCartPrice = cartProducts[0].total;

      for (int i = 0; i < cartProducts.length; i++) {
        cartProductNamesStr = ' ${cartProducts[i].productName.toString()}';
      }
    }
    //colors = cartProducts[0].colors.split(",");
    //sizes = cartProducts[0].sizes.split(",");
    print('CART UNIT PRICE:  ${cartProducts[0].unitPrice}');
    print('CART PRODUCT NAMES:  ${cartProductNamesStr}');
    print('TOTAL CART PRICE:  ${totalCartPrice}');
    print('Parsed Categories:  ${cartProducts[0].productName}');

    print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
    print('----DEBUG---Server Response: ' + '${response.body}');

    return response;
    /* } catch (e) {

     // return e;
    }*/
  }

  Future<http.Response> addProductCategory(String categoryName) async {
    try {
      //_status = Status.Authenticating;
      // notifyListeners();
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.ADD_PRODUCT_CATEGORY,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Name': categoryName,
          'Username': username,
          'Password': password,
        }),
      );
      //Register registerResp = Register.fromJson(json.decode(response.body));

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      //_status = Status.Unauthenticated;
      //  notifyListeners();
      //  print(e.toString());

      // return e;
    }
  }

  Future<http.Response> addProductBrand(String brandName) async {
    try {
      //_status = Status.Authenticating;
      // notifyListeners();
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.ADD_PRODUCT_BRAND,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'BrandName': brandName,
          'Username': username,
          'Password': password,
        }),
      );
      //Register registerResp = Register.fromJson(json.decode(response.body));

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      //_status = Status.Unauthenticated;
      //  notifyListeners();
      //  print(e.toString());

      return e;
    }
  }

  static Future<http.Response> getProductCategory() async {
    try {
      //_status = Status.Authenticating;
      // notifyListeners();
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.GET_PRODUCT_CATEGORY,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
        }),
      );
      //Register registerResp = Register.fromJson(json.decode(response.body));

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      //_status = Status.Unauthenticated;
      //  notifyListeners();
      //  print(e.toString());

      return e;
    }
  }

  static Future<http.Response> getProductBrand() async {
    try {
      //_status = Status.Authenticating;
      // notifyListeners();
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.GET_PRODUCT_BRAND,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
        }),
      );
      //Register registerResp = Register.fromJson(json.decode(response.body));

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      //_status = Status.Unauthenticated;
      //  notifyListeners();
      //  print(e.toString());

      return e;
    }
  }

  static Future<http.Response> getOrders() async {
    try {
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.GET_ORDERS,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
        }),
      );
      var ordersObjsJson = jsonDecode(response.body)['Message'] as List;
      ordersList =
          ordersObjsJson.map((tagJson) => Orders.fromJson(tagJson)).toList();

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      //_status = Status.Unauthenticated;
      //  notifyListeners();
      //  print(e.toString());

      return e;
    }
  }

  static Future<http.Response> createOrder(
      {String description, int total, String status}) async {
    try {
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.CREATE_ORDER,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Username': username,
          'CartId': password,
          'Description': description,
          'CreatedBy': username,
          'Total': total,
          'Status': status,
        }),
      );

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');
      AppConfig.totalCartPrice = 0;
      AppConfig.getCartProducts();

      return response;
    } catch (e) {


      return e;
    }
  }

  static Future<bool> addToCart(
      String productName,
      String imageUrl,
      String quantity,
      String brand,
      String unitPrice,
      String size,
      String color,
      String seller) async {
    try {
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      var response = await http.post(
        AppConfig.ADD_ITEM_TO_CART,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'CreatedBy': username,
          'ProductName': productName,
          'ImageUrl': imageUrl,
          'Quantity': quantity,
          'Brand': brand,
          'UnitPrice': unitPrice,
          'Size': size,
          'Color': color,
          'Seller': seller,
        }),
      );

      cartProductNames.add(productName);

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      Register addToCartResp = Register.fromJson(json.decode(response.body));

      if (addToCartResp.status == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return e;
    }
  }

  static Future<bool> removeFromCart(int productID) async {
    try {
      String username = await retrieveFromSharedPrefs('email');
      String password = await retrieveFromSharedPrefs('pass');
      print('----CART ITEM ID: ' + '${productID}');

      var response = await http.post(
        AppConfig.REMOVE_ITEM_FROM_CART,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Username': username,
          'id': productID,
        }),
      );

      print('----DEBUG---Server Response CODE: ' + '${response.statusCode}');
      print('----DEBUG---Server Response: ' + '${response.body}');

      Register removeItemResp = Register.fromJson(json.decode(response.body));

      if (removeItemResp.status == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return e;
    }
  }

  Future<http.Response> uploadProductToServer(
      String name,
      double price,
      String images,
      String description,
      String featured,
      int quantity,
      String brand,
      String category,
      String sale,
      List<String> sizes,
      List<String> colors,
      String createdBy) async {
    print('--IMAGES---${images.toString()}');

    try {
      var response = await http.post(ADD_PRODUCT,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            "Name": name,
            "Price": price.toString(),
            "Image": images,
            "Description": description,
            "Featured": featured,
            "Quantity": quantity.toString(),
            "Brand": brand,
            "ProductCategory": category,
            "CreatedBy": createdBy,
            "Sale": sale,
            "Sizes": sizes.join(","),
            "Colors": colors.join(","),
            "Seller": createdBy,
            // })

            /* }).catchError((err) {
      print(err);*/
          }));
      print('----DEBUG-UPLOAD PRODUCTS--Server Response CODE: ' +
          '${response.statusCode}');
      print(
          '----DEBUG--UPLOAD PRODUCTS-Server Response: ' + '${response.body}');

      return response;
    } catch (e) {
      return e;
    }
  }
}

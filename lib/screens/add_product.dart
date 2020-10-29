import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:chat_app/db/product.dart';
import 'package:chat_app/helpers/AppConfig.dart';
import 'package:chat_app/models/JSONResponseModels.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../db/category.dart';
import '../db/brand.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quatityController = TextEditingController();
  final priceController = TextEditingController();
  List<ProductBrand> brands = <ProductBrand>[];
  List<ProductCategories> categories = <ProductCategories>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File _image1;
  File _image2;
  File _image3;

  String image1String;
  String image2String;
  String image3String;

  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].category),
                value: categories[i].category));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].brand), value: brands[i].brand));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
          Icons.close,
          color: black,
        ),
        title: Text(
          "add product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                                borderSide: BorderSide(
                                    color: grey.withOpacity(0.5), width: 2.5),
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      1);
                                },
                                child: _displayChild1()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                                borderSide: BorderSide(
                                    color: grey.withOpacity(0.5), width: 2.5),
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      2);
                                },
                                child: _displayChild2()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              borderSide: BorderSide(
                                  color: grey.withOpacity(0.5), width: 2.5),
                              onPressed: () {
                                _selectImage(
                                    ImagePicker.pickImage(
                                        source: ImageSource.gallery),
                                    3);
                              },
                              child: _displayChild3(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'enter a product name with 10 characters at maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(hintText: 'Product name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the product name';
                          } else if (value.length > 10) {
                            return 'Product name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),

//              select category
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Brand: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: brandsDropDown,
                          onChanged: changeSelectedBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),

//
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: quatityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the product name';
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Price',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the product name';
                          }
                        },
                      ),
                    ),

                    Text('Available Sizes'),

                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('XS'),
                            onChanged: (value) => changeSelectedSize('XS')),
                        Text('XS'),
                        Checkbox(
                            value: selectedSizes.contains('S'),
                            onChanged: (value) => changeSelectedSize('S')),
                        Text('S'),
                        Checkbox(
                            value: selectedSizes.contains('M'),
                            onChanged: (value) => changeSelectedSize('M')),
                        Text('M'),
                        Checkbox(
                            value: selectedSizes.contains('L'),
                            onChanged: (value) => changeSelectedSize('L')),
                        Text('L'),
                        Checkbox(
                            value: selectedSizes.contains('XL'),
                            onChanged: (value) => changeSelectedSize('XL')),
                        Text('XL'),
                        Checkbox(
                            value: selectedSizes.contains('XXL'),
                            onChanged: (value) => changeSelectedSize('XXL')),
                        Text('XXL'),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('28'),
                            onChanged: (value) => changeSelectedSize('28')),
                        Text('28'),
                        Checkbox(
                            value: selectedSizes.contains('30'),
                            onChanged: (value) => changeSelectedSize('30')),
                        Text('30'),
                        Checkbox(
                            value: selectedSizes.contains('32'),
                            onChanged: (value) => changeSelectedSize('32')),
                        Text('32'),
                        Checkbox(
                            value: selectedSizes.contains('34'),
                            onChanged: (value) => changeSelectedSize('34')),
                        Text('34'),
                        Checkbox(
                            value: selectedSizes.contains('36'),
                            onChanged: (value) => changeSelectedSize('36')),
                        Text('36'),
                        Checkbox(
                            value: selectedSizes.contains('38'),
                            onChanged: (value) => changeSelectedSize('38')),
                        Text('38'),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: selectedSizes.contains('40'),
                            onChanged: (value) => changeSelectedSize('40')),
                        Text('40'),
                        Checkbox(
                            value: selectedSizes.contains('42'),
                            onChanged: (value) => changeSelectedSize('42')),
                        Text('42'),
                        Checkbox(
                            value: selectedSizes.contains('44'),
                            onChanged: (value) => changeSelectedSize('44')),
                        Text('44'),
                        Checkbox(
                            value: selectedSizes.contains('46'),
                            onChanged: (value) => changeSelectedSize('46')),
                        Text('46'),
                        Checkbox(
                            value: selectedSizes.contains('48'),
                            onChanged: (value) => changeSelectedSize('48')),
                        Text('48'),
                        Checkbox(
                            value: selectedSizes.contains('50'),
                            onChanged: (value) => changeSelectedSize('50')),
                        Text('50'),
                      ],
                    ),

                    FlatButton(
                      color: red,
                      textColor: white,
                      child: Text('add product'),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _getCategories() async {
    var response = await AppConfig.getProductCategory();
    AppConfig.getProducts();

    print('Raw Message: ${response.body}');
    var categoriesObjsJson = jsonDecode(response.body)['Message'] as List;
    List<ProductCategories> categoriesObjs = categoriesObjsJson
        .map((tagJson) => ProductCategories.fromJson(tagJson))
        .toList();
    print('Parsed Categories:  ${categoriesObjs[0].category}');
    setState(() {
      for (int i = 0; i < categoriesObjsJson.length; i++) {
        categories = categoriesObjs;
        categoriesDropDown = getCategoriesDropdown();
        _currentCategory = categoriesObjs[i].category.toString();
      }
    });
  }

  _getBrands() async {
    var response = await AppConfig.getProductBrand();
    Register productCategoryResp =
        Register.fromJson(json.decode(response.body));

    var brandsObjsJson = jsonDecode(response.body)['Message'] as List;
    List<ProductBrand> brandsObjs = brandsObjsJson
        .map((tagJson) => ProductBrand.fromJson(tagJson))
        .toList();

    setState(() {
      for (int i = 0; i < brandsObjsJson.length; i++) {
        brands = brandsObjs;
        brandsDropDown = getBrandosDropDown();
        _currentBrand = brands[i].brand;
        print('Parsed Brands:  ${brandsObjs[i].brand}');
      }
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentCategory = selectedBrand);
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        final bytes = Io.File(_image1.path).readAsBytesSync();
        image1String = base64Encode(bytes);

        break;
      case 2:
        setState(() => _image2 = tempImg);
        final bytes = Io.File(_image2.path).readAsBytesSync();
        image2String = base64Encode(bytes);
        break;

      case 3:
        setState(() => _image3 = tempImg);
        final bytes = Io.File(_image3.path).readAsBytesSync();
        image3String = base64Encode(bytes);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    //  if (_formKey.currentState.validate()) {
    setState(() => isLoading = true);
    if (_image1 != null && _image2 != null && _image3 != null) {
      if (selectedSizes.isNotEmpty) {
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;

        /*
          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(_image1);
          final String picture2 =
              "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task2 =
              storage.ref().child(picture2).putFile(_image2);
          final String picture3 =
              "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task3 =
              storage.ref().child(picture3).putFile(_image3);

          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);
          StorageTaskSnapshot snapshot2 =
              await task2.onComplete.then((snapshot) => snapshot);

        task3.onComplete.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();*/

        /*  productService.uploadProduct({
              "name": productNameController.text,
              "price": double.parse(priceController.text),
              "sizes": selectedSizes,
              "images": imageList,
              "quantity": int.parse(quatityController.text),
              "brand": _currentBrand,
              "category": _currentCategory
            });*/

        imageUrl1 = base64Encode(_image1.readAsBytesSync());
        imageUrl2 = base64Encode(_image2.readAsBytesSync());
        imageUrl3 = base64Encode(_image3.readAsBytesSync());

        List<String> imageList = [image1String, image2String, image3String];

        String imageString = image1String;

        print('--IMAGES---${imageList.toString()}');
        String username = await AppConfig.retrieveFromSharedPrefs('email');

        var response = await AppConfig().uploadProductToServer(
            productNameController.text,
            double.parse(priceController.text),
            imageString,
            "Product",
            "Yes",
            int.parse(quatityController.text),
            _currentBrand,
            _currentCategory,
            "Two",
            selectedSizes,
            ["Yellow,Green"],
            username);

        _formKey.currentState.reset();
        setState(() => isLoading = false);

        Register uploadResponse = Register.fromJson(json.decode(response.body));

        if (uploadResponse.status != null) {
          Fluttertoast.showToast(msg: '${uploadResponse.message}');
          Navigator.pop(context);
        }
        // });
      } else {
        setState(() => isLoading = false);

        Fluttertoast.showToast(msg: 'select atleast one size');
      }
    } else {
      setState(() => isLoading = false);

      Fluttertoast.showToast(msg: 'all the images must be provided');
    }
  }
}
//}

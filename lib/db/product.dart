import 'dart:convert';

import 'package:chat_app/helpers/AppConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  File file;

  /*void uploadProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String productId = id.v1();
    data["id"] = productId;
    _firestore.collection(ref).document(productId).setData(data);
  }*/

  void _choose() async {
    //file = (await ImagePicker.pickImage(source: ImageSource.camera)) as File;
    file = await ImagePicker.pickImage(source: ImageSource.gallery) as File;
  }


}

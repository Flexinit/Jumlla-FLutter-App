import 'package:chat_app/helpers/AppConfig.dart';
import 'package:chat_app/helpers/style.dart';
import 'package:chat_app/models/order.dart';
import 'package:chat_app/provider/app.dart';
import 'package:chat_app/provider/user.dart';
import 'package:chat_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: AppConfig.ordersList.length,
          itemBuilder: (_, index){
            return ListTile(
              leading: CustomText(
                text: "\KES${AppConfig.ordersList[index].total}",
                weight: FontWeight.bold,
              ),
              title: Text(AppConfig.ordersList[index].description),
              subtitle: Text(AppConfig.ordersList[index].createdate),
              trailing: CustomText(text: AppConfig.ordersList[index].orderStatus, color: green,),
            );
          }),
    );
  }
}

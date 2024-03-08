import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project02/loadimage.dart';
class ProductItem extends StatefulWidget {
  final String uid;
  const ProductItem({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String titles ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();

  }
  void loadData() async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("products").doc(widget.uid.toString()).get();
    setState(() {
      titles = ds.get("title");

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
            child:Column(children: [
              Text(titles),
              ElevatedButton(onPressed: () {
                FirebaseFirestore.instance.collection("products").doc(widget.uid).delete();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));

              }, child: Text("Delete"))

            ],) ,

          )),
    );
  }
}
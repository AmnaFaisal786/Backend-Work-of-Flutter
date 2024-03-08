import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cartitem.dart';
class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(stream: FirebaseFirestore.instance.collection("products").snapshots(),

      builder:(context, snapshot) {
        List<Map<String, dynamic>> products = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
          itemCount: products.length,
          itemBuilder:(context, index) {

            return GestureDetector(
              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductItem(uid: snapshot.data!.docs[index].id.toString()),));
                print(snapshot.data!.docs[index].id.toString());
              },
              child: Card(
                elevation: 2,
                color: Colors.orange,
                child: Column(
                  children: [
                    Text(products[index]['title']),
                    Text(products[index]['price'].toString()),
                    Text(snapshot.data!.docs[index].id.toString())
                  ],
                ),
              ),
            );
          }, );
      },);
  }
}
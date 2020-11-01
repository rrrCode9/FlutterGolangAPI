import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:GoFlutterCommunicationApp/product.dart';

void main() {
  runApp(ApiApp());
}

class ApiApp extends StatefulWidget {
  ApiApp({Key key}) : super(key: key);

  @override
  _ApiAppState createState() => _ApiAppState();
}

class _ApiAppState extends State<ApiApp> {
  
 
  double fetchCountPercentage = 10;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: SizedBox.expand(
          child: Stack(children: [
        FutureBuilder<List<Product>>(
          future: fetchOperation(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("${snapshot.hasData}**");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print("herree");
              return Center(child:Text("Server Error!", style: TextStyle(color: Colors.red[300],fontSize: 20),
              ));
            }

            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text("Count: ${snapshot.data[index].count} \t Price: ${snapshot.data[index].price}"),
                    ));
                  });
            }
          },
        ),
        Positioned(
            bottom: 5,
            right: 5,
            child: Slider(
              value: fetchCountPercentage,
              min: 0,
              max: 100,
              divisions: 10,
              label: fetchCountPercentage.round().toString(),
              onChanged: (double value) {
                setState(() {
                  fetchCountPercentage = value;
                });
              },
            )),
      ])),
    ));
  }

  Future<List<Product>> fetchOperation() async {
    var url = 'http://65.0.125.153:5500/products/${fetchCountPercentage.round()}';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    List<Product> productList = [];
    if (response.statusCode == 200){
      var productMap = jsonDecode(response.body);
      for (final el in productMap) {
      productList.add(Product.fromJson(el));
    }

    }
    

    return productList;
  }
}

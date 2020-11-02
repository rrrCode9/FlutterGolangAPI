import 'package:flutter/material.dart';
import 'package:app_demo_api/productModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(AppDemo());
}

class AppDemo extends StatefulWidget {
  AppDemo({Key key}) : super(key: key);

  @override
  _AppDemoState createState() => _AppDemoState();
}

class _AppDemoState extends State<AppDemo> {
  double fetchCountPercentage = 20.0; // default 10%

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.blueGrey,
            body: SizedBox.expand(
                child: Stack(
              children: [
                FutureBuilder<List<Product>>(
                  future: fetchFromServer(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}", style: TextStyle(color: Colors.redAccent)),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: ListTile(
                            title: Text(snapshot.data[index].name),
                            subtitle: Text("Count: ${snapshot.data[index].count} \t Price:${snapshot.data[index].price}"),
                          ));
                        },
                      );
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
                      label: fetchCountPercentage.toString(),
                      onChanged: (double value) {
                        setState(() {
                          fetchCountPercentage = value;
                        });
                      },
                    ))
              ],
            ))));
  }

  Future<List<Product>> fetchFromServer() async {
    var url = "http://65.0.125.153:5500/products/$fetchCountPercentage";
    var response = await http.get(url);

    List<Product> productList = [];
    if (response.statusCode == 200) {
      var productMap = convert.jsonDecode(response.body);
      for (final item in productMap) {
        productList.add(Product.fromJson(item));
      }
    }

    return productList;
  }
}

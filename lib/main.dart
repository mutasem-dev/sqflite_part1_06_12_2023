import 'package:flutter/material.dart';
import 'package:product_sqlite2/database_provider.dart';
import 'package:product_sqlite2/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
TextEditingController nameController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController priceController = TextEditingController();
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  _showDialog(BuildContext context,String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Info',
          style: TextStyle(fontSize: 22.0, color: Colors.indigo),),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(color: Colors.black,height: 2,),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'product name'
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                    labelText: 'quantity'
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: const InputDecoration(
                    labelText: 'price'
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if(type == 'add') {
                Product p = Product(
                    name: nameController.text,
                    quantity: int.parse(quantityController.text),
                    price: double.parse(priceController.text)
                );
                DatabaseProvider.db.insertProduct(p).then((value){
                SnackBar snackBar = SnackBar(content:
                  Text('${p.name} add at rowId $value' ));
                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
                nameController.clear();
                quantityController.clear();
                priceController.clear();
              }

              setState(() {

              });
              Navigator.of(context).pop();
            },
            child: Text(type == 'add' ? 'add' : 'update'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products app'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Products:', style: TextStyle(fontSize: 24),),
              ElevatedButton(
                  onPressed: () {
                    _showDialog(context, 'add');
                  },
                  child: Text('add product'),
              ),
            ],

          ),
          FutureBuilder(
              future: DatabaseProvider.db.getAllProducts(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Product>? products = snapshot.data;
                  if(products!.isEmpty)
                    return Text('no products found', style: TextStyle(fontSize: 24),);
                  else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.blue,
                            leading: Text(products[index].name, style: TextStyle(fontSize: 20)),
                            title: Text('Quantity: ${products[index].quantity}'),
                            subtitle: Text('Price: ${products[index].price}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                } else if(snapshot.hasError) {
                  return Text('error ${snapshot.error}', style: TextStyle(fontSize: 24),);
                }
                else {
                  return CircularProgressIndicator();
                }
              },
          ),
        ],
      ),
    );
  }
}


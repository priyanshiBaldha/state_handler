import 'package:flutter/material.dart';
import 'package:food_app/modals/productModal.dart';
import 'package:food_app/providers/CartProvider.dart';
import 'package:provider/provider.dart';

import '../../helpers/db_heper.dart';
import '../../providers/ThemeProvider.dart';

class product_home_page_page extends StatefulWidget {
  const product_home_page_page({Key? key}) : super(key: key);

  @override
  State<product_home_page_page> createState() => _product_home_page_pageState();
}

late Future<List<Product>> getAllData;

late TabController tabController2;

int initialTabIndex2 = 0;

class _product_home_page_pageState extends State<product_home_page_page>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController2 = TabController(length: 4, vsync: this, initialIndex: 0);
    getAllData = DBHleper.dbHleper.fetchSearchedRecode(data: "Salad");
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _height * 0.05),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.list,
                      color: Colors.green,
                    )),
                SizedBox(width: _width * 0.19),
                Icon(Icons.add_location_alt, color: Colors.green),
                SizedBox(width: 3),
                Text(
                  "Surat,Gujarat",
                  style: TextStyle(color: Colors.grey, fontSize: _width * 0.05),
                ),
                SizedBox(width: _width * 0.09),
                Switch(
                    value: Provider.of<ThemeProvider>(context).isdrk,
                    onChanged: (val) {
                      Provider.of<ThemeProvider>(context, listen: false).changeTheme();
                    }),
              ],
            ),
            SizedBox(height: _height * 0.02),
            Text("Hi,Priyanshi",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: _height * 0.016),
            Text("Find Your Food",
                style: TextStyle(
                    fontSize: _width * 0.07, fontWeight: FontWeight.bold)),
            SizedBox(height: _height * 0.02),
            Container(
              height: _height * 0.07,
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  SizedBox(width: _width * 0.01),
                  Icon(Icons.search, color: Colors.green),
                  Text(" Search Food",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: _height * 0.02),
            TabBar(
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                controller: tabController2,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.green,
                onTap: (value) {
                  setState(() {
                    initialTabIndex2 = value;
                    if (initialTabIndex2 == 0) {
                      getAllData =
                          DBHleper.dbHleper.fetchSearchedRecode(data: "Salad");
                    }

                    if (initialTabIndex2 == 1) {
                      getAllData =
                          DBHleper.dbHleper.fetchSearchedRecode(data: "Fruits");
                    }
                    if (initialTabIndex2 == 2) {
                      getAllData = DBHleper.dbHleper
                          .fetchSearchedRecode(data: "Grocery");
                    }
                    if (initialTabIndex2 == 3) {
                      getAllData =
                          DBHleper.dbHleper.fetchSearchedRecode(data: "Veges");
                    }
                  });
                },
                tabs: [
                  Tab(
                    text: "    Food     ",
                  ),
                  Tab(
                    text: "     Fruit      ",
                  ),
                  Tab(
                    text: "    Grocery     ",
                  ),
                  Tab(
                    text: "    Vegetable",
                  )
                ]),
            FutureBuilder(
              future: getAllData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<Product>? data = snapshot.data;
                  return Container(
                    height: _height * 0.5,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 5),
                      itemCount: data!.length,
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Image.asset(data[i].image,
                                    height: _height * 0.12),
                                Text("${data[i].name}"),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (data[i].quantity == 0) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(
                                                        product: data[i]);
                                              } else {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .RemoveFromCart(
                                                        product: data[i]);
                                              }
                                            });
                                          },
                                          icon: (data[i].quantity == 0)
                                              ? Icon(Icons.shopping_cart)
                                              : Icon(Icons
                                                  .remove_shopping_cart_outlined))
                                    ]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}

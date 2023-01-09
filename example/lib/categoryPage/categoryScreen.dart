import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/categoryPage/categoryBloc.dart';
import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/manageInventory.dart';

class CategoryScreen extends StatefulWidget {
  final List<DynamicInventory> inventory;
  final String brandId;

  const CategoryScreen(
      {Key? key, required this.inventory, required this.brandId})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late CategoryBloc categoryBloc;

  Widget loading() {
    return StreamBuilder<bool>(
        stream: categoryBloc.loadingCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return const Material(
                color: Color(0xff70000000),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink,
                  ),
                ));
          }
          return Container();
        });
  }

  Widget cardView(String productCode, String imageUrl, int itemIndex,
      String category, String categoryType) {
    return GestureDetector(
      onTap: () => setState(() {
        categoryBloc.inventory
                    .firstWhere((element) => element.category == category)
                    .inventoryResponse
                    .data[itemIndex]
                    .isChecked ==
                true
            ? categoryBloc.inventory
                .firstWhere((element) => element.category == category)
                .inventoryResponse
                .data[itemIndex]
                .isChecked = false
            : categoryBloc.inventory
                .firstWhere((element) => element.category == category)
                .inventoryResponse
                .data[itemIndex]
                .isChecked = true;
        if (categoryBloc.inventory
            .firstWhere((element) => element.category == category)
            .inventoryResponse
            .data[itemIndex]
            .isChecked) {
          if (!categoryBloc.selectedItems.containsKey(category)) {
            categoryBloc.selectedItems[category] = {
              "items": [],
              "type": categoryType
            };
          }
          categoryBloc.selectedItems[category]!["items"]!.add(productCode);
        } else {
          categoryBloc.selectedItems[category]!.remove({
            "items": [productCode],
          });
        }
      }),
      child: Card(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (categoryType == "ear")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 70,
                        child: Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  const Icon(Icons.warning),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.warning),
                              fit: BoxFit.scaleDown,
                            )),
                      ),
                      SizedBox(
                          height: 70,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const Icon(Icons.warning),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.warning),
                            fit: BoxFit.scaleDown,
                          ))
                    ],
                  ),
                if (categoryType != "ear")
                  SizedBox(
                      height: 90,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.warning),
                        placeholder: (context, url) =>
                            const Icon(Icons.warning),
                        fit: BoxFit.scaleDown,
                      )),
                const SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                    value: categoryBloc.inventory
                        .firstWhere((element) => element.category == category)
                        .inventoryResponse
                        .data[itemIndex]
                        .isChecked,
                    onChanged: ((value) {
                      setState(() {
                        categoryBloc.inventory
                            .firstWhere(
                                (element) => element.category == category)
                            .inventoryResponse
                            .data[itemIndex]
                            .isChecked = value!;
                        if (value) {
                          if (!categoryBloc.selectedItems
                              .containsKey(category)) {
                            categoryBloc.selectedItems[category] = {
                              "items": [],
                              "type": categoryType
                            };
                          }
                          categoryBloc.selectedItems[category]!["items"]!
                              .add(productCode);
                        } else {
                          categoryBloc.selectedItems[category]!.remove({
                            "items": [productCode],
                          });
                        }
                      });
                    }),
                    title: AutoSizeText(
                      productCode,
                      maxLines: 2,
                    ))
              ],
            ),
          ),
        ),
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      ),
    );
  }

  Widget cardView2(String productCode, String imageUrl1, String imageUrl2,
      int itemIndex, String category, String categoryType) {
    return GestureDetector(
      onTap: () => setState(() {
        categoryBloc.inventory
                    .firstWhere((element) => element.category == category)
                    .inventoryResponse
                    .data[itemIndex]
                    .isChecked ==
                true
            ? categoryBloc.inventory
                .firstWhere((element) => element.category == category)
                .inventoryResponse
                .data[itemIndex]
                .isChecked = false
            : categoryBloc.inventory
                .firstWhere((element) => element.category == category)
                .inventoryResponse
                .data[itemIndex]
                .isChecked = true;

        if (categoryBloc.inventory
            .firstWhere((element) => element.category == category)
            .inventoryResponse
            .data[itemIndex]
            .isChecked) {
          if (!categoryBloc.selectedItems.containsKey(category)) {
            categoryBloc.selectedItems[category] = {
              "items": [],
              "type": categoryType
            };
          }
          categoryBloc.selectedItems[category]!["items"]!.add(productCode);
        } else {
          categoryBloc.selectedItems[category]!.remove({
            "items": [productCode],
          });
        }
      }),
      child: Card(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (categoryType == "set")
                  SizedBox(
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl2,
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.warning),
                        placeholder: (context, url) =>
                            const Icon(Icons.warning),
                        fit: BoxFit.scaleDown,
                      )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Transform(
                          transform: Matrix4.rotationY(pi),
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                const Icon(Icons.warning),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.warning),
                            imageUrl: imageUrl1,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    SizedBox(
                        height: 40,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const Icon(Icons.warning),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.warning),
                          imageUrl: imageUrl1,
                          fit: BoxFit.scaleDown,
                        ))
                  ],
                ),
                if (categoryType == "ear")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 70,
                        child: Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const Icon(Icons.warning),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.warning),
                              imageUrl: imageUrl1,
                              fit: BoxFit.scaleDown,
                            )),
                      ),
                      SizedBox(
                          height: 70,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                const Icon(Icons.warning),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.warning),
                            imageUrl: imageUrl1,
                            fit: BoxFit.scaleDown,
                          ))
                    ],
                  ),
                if (categoryType != "ear" && categoryType != "set")
                  SizedBox(
                      height: 90,
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const Icon(Icons.warning),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.warning),
                        imageUrl: imageUrl1,
                        fit: BoxFit.scaleDown,
                      )),
                const SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                    value: categoryBloc.inventory
                        .firstWhere((element) => element.category == category)
                        .inventoryResponse
                        .data[itemIndex]
                        .isChecked,
                    onChanged: ((value) {
                      setState(() {
                        categoryBloc.inventory
                            .firstWhere(
                                (element) => element.category == category)
                            .inventoryResponse
                            .data[itemIndex]
                            .isChecked = value!;
                        if (value) {
                          if (!categoryBloc.selectedItems
                              .containsKey(category)) {
                            categoryBloc.selectedItems[category] = {
                              "items": [],
                              "type": categoryType
                            };
                          }
                          categoryBloc.selectedItems[category]!["items"]!
                              .add(productCode);
                        } else {
                          categoryBloc.selectedItems[category]!.remove({
                            "items": [productCode],
                          });
                        }
                      });
                    }),
                    title: AutoSizeText(
                      productCode,
                      maxLines: 2,
                    ))
              ],
            ),
          ),
        ),
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      ),
    );
  }

  @override
  void initState() {
    categoryBloc = CategoryBloc(
        inventory: widget.inventory, brandId: widget.brandId, context: context);
    categoryBloc.tabController =
        TabController(length: widget.inventory.length, vsync: this);
    categoryBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    categoryBloc.tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [body(), loading()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          categoryBloc.onSubmit();
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: TabBar(
                isScrollable: true,
                controller: categoryBloc.tabController,
                tabs: categoryBloc.tabs,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              )),
          Expanded(
            child: StreamBuilder<bool>(
                initialData: true,
                stream: categoryBloc.loadingCtrl.stream,
                builder: (context, value) {
                  if (value.hasData && value.data == true) {
                    return TabBarView(
                        controller: categoryBloc.tabController,
                        children: [
                          for (var i in categoryBloc.inventory)
                            GridView.builder(
                              controller: categoryBloc.gridScrollController,
                              key: PageStorageKey<String>(i.category),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (_, index) {
                                if (i.inventoryResponse.data.isEmpty) {
                                  return const Center(
                                    child: Text("No Data Found"),
                                  );
                                }
                                if (i.categoryType == "set") {
                                  var earKey = i.setData["earring_data"];
                                  var neckKey = i.setData["necklace_data"];

                                  return cardView2(
                                      i.inventoryResponse.data[index]
                                          .productCode,
                                      i.inventoryResponse.data[index]
                                                  .rawData[earKey]["data"]
                                              ["image_url"] ??
                                          "",
                                      i.inventoryResponse.data[index]
                                                  .rawData[neckKey]["data"]
                                              ["image_url"] ??
                                          "",
                                      index,
                                      i.category,
                                      i.categoryType);
                                }

                                return cardView(
                                    i.inventoryResponse.data[index].productCode,
                                    i.inventoryResponse.data[index].data
                                        .imageUrl,
                                    index,
                                    i.category,
                                    i.categoryType);
                              },
                              itemCount: i.inventoryResponse.data.length,
                            ),
                        ]);
                  }
                  return Container();
                }),
          )
        ],
      ),
    );
  }
}

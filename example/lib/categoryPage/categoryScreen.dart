import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/categoryPage/categoryBloc.dart';
import 'package:plugin_mirrar_example/models/categoriesResponse.dart';
import 'package:plugin_mirrar_example/models/inventoryResponse.dart';
import 'package:plugin_mirrar_example/models/manageInventory.dart';
import 'package:plugin_mirrar_example/models/selectedItemsRequest.dart';

class CategoryScreen extends StatefulWidget {
  final List<ManageInventory> inventory;
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

  Widget cardView(String productCode, String imageUrl, int itemIndex,
      String category, String categoryType) {
    // for(var i in categoryBloc.selectedProductCodes)
    // controller.deselectValues(categoryBloc.selectedProductCodes);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 90,
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.scaleDown,
                ),
              ),
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
                        .firstWhere((element) => element.category == category)
                        .inventoryResponse
                        .data[itemIndex]
                        .isChecked = value!;
                    categoryBloc.inventory
                        .firstWhere((element) => element.category == category)
                        .isChecked = value;
                    print("$category,$itemIndex");
                  });
                }),
                title: Text(
                  productCode,
                  textScaleFactor: 0.8,
                ),
              )
            ],
          ),
        ),
      ),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
      body: body(),
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
            child:
                TabBarView(controller: categoryBloc.tabController, children: [
              for (var i in categoryBloc.inventory)
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (_, index) {
                    if (i.inventoryResponse.data.isEmpty) {
                      return const Center(
                        child: Text("No Data Found"),
                      );
                    }
                    return cardView(
                        i.inventoryResponse.data[index].productCode,
                        i.inventoryResponse.data[index].data.imageUrl,
                        index,
                        i.category,
                        i.categoryType);
                  },
                  itemCount: i.inventoryResponse.data.length,
                ),
            ]),
          )
        ],
      ),
    );
  }
}

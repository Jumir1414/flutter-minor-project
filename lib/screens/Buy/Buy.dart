import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:minorproject/screens/Drawer/Drawer_Screen.dart';
import 'package:minorproject/services/db_service.dart';
import 'package:minorproject/utils/form_helper.dart';
import 'package:minorproject/services/db_service.dart';
import 'package:minorproject/models/data_model.dart';

import 'ViewProduct.dart';

class BuyScreen extends KFDrawerContent {
  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  DBService dbService;
  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }

  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text('LIST OF BOOKS'),
          elevation: 0,
        ),
        body: _fetchData(),
      ),
      onWillPop: onBackPressed,
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<ProductModel>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
        if (products.hasData) {
          return _buildUI(products.data);
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildUI(List<ProductModel> products) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(products)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _buildDataTable(List<ProductModel> model) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Book Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Price",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    data.productName,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    data.price.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.read_more),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewProduct(
                                isEditMode: true,
                                model: data,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
              ],
            ),
          )
          .toList(),
    );
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return DrawerScreen();
      },
    ), (route) => false);
  }
}

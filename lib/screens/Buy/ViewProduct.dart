import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minorproject/models/data_model.dart';
import 'package:minorproject/services/db_service.dart';
import 'package:minorproject/utils/form_helper.dart';

class ViewProduct extends StatefulWidget {
  ViewProduct({Key key, this.model, this.isEditMode = false}) : super(key: key);
  ProductModel model;
  bool isEditMode;

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  ProductModel model;
  DBService dbService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    model = new ProductModel();

    if (widget.isEditMode) {
      model = widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "View Product" : "Add BOOKS"),
      ),
      body: new Form(
        key: globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FormHelper.fieldLabel("BOOK Name,Book Publication and edition"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  model.productName,
                ),
                SizedBox(
                  height: 30,
                ),
                FormHelper.fieldLabel("Seller contacts"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  model.productDesc,
                ),
                SizedBox(
                  height: 30,
                ),
                FormHelper.fieldLabel("Book Price"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  model.price.toString(),
                ),
                SizedBox(
                  height: 30,
                ),
                FormHelper.fieldLabel("Book Category"),
                _productCategory(),
                FormHelper.fieldLabel("View Product Photo"),
                FormHelper.picPicker(
                  model.productPic,
                  (file) => {
                    setState(
                      () {
                        model.productPic = file.path;
                      },
                    )
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCategory() {
    return FutureBuilder<List<CategoryModel>>(
      future: dbService.getCategories(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CategoryModel>> categories) {
        if (categories.hasData) {
          return FormHelper.selectDropdown(
            context,
            model.categoryId,
            categories.data,
            (value) => {this.model.categoryId = int.parse(value)},
            onValidate: (value) {
              if (value == null) {
                return 'Please enter Product Category.';
              }
              return null;
            },
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

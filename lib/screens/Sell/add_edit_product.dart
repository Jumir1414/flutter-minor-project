import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minorproject/models/data_model.dart';
import 'package:minorproject/screens/Sell/Sell.dart';
import 'package:minorproject/services/db_service.dart';
import 'package:minorproject/utils/form_helper.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({Key key, this.model, this.isEditMode = false})
      : super(key: key);
  ProductModel model;
  bool isEditMode;

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
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
        title: Text(widget.isEditMode ? "Edit Product" : "Add BOOKS"),
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
              children: [
                FormHelper.fieldLabel("BOOK Name,Publication and edition"),
                FormHelper.textInput(
                  context,
                  model.productName,
                  (value) => {
                    this.model.productName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Book Name,Publication and edition';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Sellers contacts"),
                FormHelper.textInput(
                    context,
                    model.productDesc,
                    (value) => {
                          this.model.productDesc = value,
                        },
                    isTextArea: true, onValidate: (value) {
                  return null;
                }),
                FormHelper.fieldLabel("Book Price"),
                FormHelper.textInput(
                  context,
                  model.price,
                  (value) => {
                    this.model.price = double.parse(value),
                  },
                  isNumberInput: true,
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter price.';
                    }

                    if (value.toString().isNotEmpty &&
                        double.parse(value.toString()) <= 0) {
                      return 'Please enter valid price.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Book Category"),
                _productCategory(),
                FormHelper.fieldLabel("Select Product Photo"),
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
                btnSubmit(),
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

  Widget btnSubmit() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            print(model.toMap());
            if (widget.isEditMode) {
              dbService.updateProduct(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "BUY SELL BOOKS",
                  "Data Submitted Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellScreen(),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addProduct(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "BUY SELL BOOKS",
                  "Data Modified Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellScreen(),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 40.0,
          margin: EdgeInsets.all(10),
          width: 100,
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              "Save Product",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");

  var _isInit = true;
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
    print("Focus");
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;

        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          /* "imageUrl": _editedProduct.imageUrl, */
          "imageUrl": "",
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);

    if (_editedProduct.id != null) {
      //IM editing
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      //Context esta disponible en cualquier parte en mi state object
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    //Se agrego el producto
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues["title"],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a value";
                  }
                  return null; //Input is correcto
                },
              ),
              TextFormField(
                initialValue: _initValues["price"],
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a value";
                  } else if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  } else if (double.parse(value) <= 0) {
                    return "Please enter a number greater than zero";
                  }
                  return null; //Input is correcto
                },
              ),
              TextFormField(
                initialValue: _initValues["description"],
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a description";
                  } else if (value.length < 10) {
                    return "Should be at least 10 characters long";
                  }
                  return null; //Input is correcto
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Expanded(
                    child: TextFormField(
                      /* initialValue: _initValues["imageUrl"], */
                      /*No podemos poner initial value y al mismo tiempo
                      usar un controller ya que genera error, por que? idk */
                      decoration: InputDecoration(labelText: "Image URL"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter an image URL";
                        } else if (!value.startsWith("http") &&
                            !value.startsWith("https")) {
                          return "Please enter a valid URL";
                        } else if (!value.endsWith(".png") &&
                            !value.endsWith(".jpg") &&
                            !value.endsWith(".jpeg")) {
                          return "Please enter a valid image URL";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
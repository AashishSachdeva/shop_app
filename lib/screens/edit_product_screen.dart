import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Manage-Products/Edit-Product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(title: '', description: '', id: '', imageUrl: '', price: 0);
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateUrl);
    super.initState();
  }

  var initStatus = true;
  var _isLoading = false;
  late final Map<String, String> initValues;
  @override
  void didChangeDependencies() {
    if (initStatus && ModalRoute.of(context)!.settings.arguments != null) {
      final String productId =
          (ModalRoute.of(context)!.settings.arguments as String);
      _editedProduct = Provider.of<Products>(context)
          .items
          .firstWhere((prod) => prod.id == productId);
    }
    initValues = {
      'title': _editedProduct.title,
      'price': _editedProduct.price.toString(),
      'description': _editedProduct.description,
      // 'imageUrl': _editedProduct.imageUrl,
    };
    _imageUrlController.text = _editedProduct.imageUrl;

    initStatus = false;
    super.didChangeDependencies();
  }

  void _updateUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          (!_imageUrlController.text.startsWith('https')))) return;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateUrl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    if (_editedProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _form,
        child: SingleChildScrollView(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter a title';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            title: value as String,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a price';
                          if (double.tryParse(value) == null)
                            return 'Please enter valid price';
                          if (double.parse(value) <= 0)
                            return 'Price must be grater than 0';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value as String),
                          );
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Description must be more than 10 characters';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value as String,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text(
                                      'Enter URL',
                                      textAlign: TextAlign.center,
                                    )
                                  : Image.network(_imageUrlController.text)),
                          Expanded(
                            child: TextFormField(
                              initialValue: initValues['imageUrl'],
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter a image URL';
                                if (!value.startsWith('http') &&
                                    (!value.startsWith('https')))
                                  return 'Enter a valid Url';
                                // if (!value.endsWith('.jpeg') &&
                                //     !value.endsWith(".png") &&
                                //     !value.endsWith(".jpg"))
                                //   return 'Enter a valid image URL';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: value as String,
                                  price: _editedProduct.price,
                                );
                              },
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

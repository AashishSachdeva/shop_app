import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/appDrawer.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
// import 'package:shop_app/provider/product.dart';
import 'package:shop_app/widgets/products_grid.dart';
import '../provider/cart.dart';

enum FilterOptions {
  onlyFavorites,
  showAll,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavsOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.onlyFavorites) {
                  _showFavsOnly = true;
                } else {
                  _showFavsOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.onlyFavorites,
                child: Text("Favorites"),
              ),
              PopupMenuItem(
                value: FilterOptions.showAll,
                child: Text("Show all"),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              child: child as Widget,
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavsOnly),
      drawer: AppDrawer(),
    );
  }
}

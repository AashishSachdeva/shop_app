import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/orders.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem orderData;
  OrderListItem(this.orderData);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderData.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderData.time),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: _isExpanded
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
            ),
          ),
          if (_isExpanded)
            Container(
              height: min(widget.orderData.cartItems.length * 20.0 + 100, 100),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView(
                  children: widget.orderData.cartItems.map((prod) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prod.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${prod.price} * ${prod.quantity}',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )
                  ],
                );
              }).toList()),
            )
        ],
      ),
    );
  }
}

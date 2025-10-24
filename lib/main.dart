import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Center(
          child: Container(
            color: Colors.red,
            width: 350,
            height: 350,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // try center, spaceAround, spaceBetween, etc.
              crossAxisAlignment:
                  CrossAxisAlignment.center, // try start, end, stretch
              children: const [
                OrderItemDisplay(5, 'Footlong'),
                OrderItemDisplay(3, 'BLT'),
                OrderItemDisplay(1, 'Club'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: TextStyle(
        fontSize: 20.0, //+ quantity.toDouble() * 2.0,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

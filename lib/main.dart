import 'package:flutter/material.dart';
import 'package:flutter_staggered_animation/animated_box.dart';

void main() => runApp(MaterialApp(home: StaggeredPackageUnboxing()));

class StaggeredPackageUnboxing extends StatefulWidget {
  @override
  _StaggeredPackageUnboxingState createState() =>
      _StaggeredPackageUnboxingState();
}

class _StaggeredPackageUnboxingState extends State<StaggeredPackageUnboxing> {
  final GlobalKey _cartIconKey = GlobalKey();
  bool _showAnimation = false;

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('Order Successful!', style: TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Flutter Demo"),
        backgroundColor: Colors.brown.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.shopping_cart,
              key: _cartIconKey,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_showAnimation)
            Center(
              child: UnboxingAnimation(
                cartIconKey: _cartIconKey,
                onComplete: () {
                  setState(() => _showAnimation = false);
                  _showSuccessMessage();
                },
              ),
            ),
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: ElevatedButton(
              onPressed: () => setState(() => _showAnimation = true),
              child: const Text(
                "Place Order",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

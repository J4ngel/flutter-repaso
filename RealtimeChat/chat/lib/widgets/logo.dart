import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;
  final AssetImage img;

  const Logo({super.key, required this.title, required this.img});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image(
              image: this.img,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              this.title,
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final String route;

  const Labels(
      {super.key,
      required this.textOne,
      required this.textTwo,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            this.textOne,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.route);
            },
            child: Text(
              this.textTwo,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

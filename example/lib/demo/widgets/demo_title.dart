import 'package:flutter/material.dart';

class DemoTitle extends StatelessWidget {
  const DemoTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25.0,
        ),
      ),
    );
  }
}

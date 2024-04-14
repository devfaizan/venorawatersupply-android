import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback doThis;
  const RoundButton({super.key, required this.title, required this.doThis});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(6),
      child: MaterialButton(
        color: Color.fromARGB(255, 85, 88, 195),
        height: 50,
        minWidth: double.infinity,
        onPressed: doThis,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

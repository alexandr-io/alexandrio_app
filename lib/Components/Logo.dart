import 'package:flutter/material.dart';

import '../ThemeBuilder.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = ThemeBuilder.of(context).accentOnBackgroundGlobal(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.book,
          color: color,
        ),
        Text(
          "Alexandrio",
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}

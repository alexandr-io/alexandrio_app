import 'dart:ui';

import 'package:flutter/material.dart';

class WidgetBlur extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget widget;

  const WidgetBlur({
    Key key,
    @required this.widget,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(0.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Material(
                color: Colors.transparent,
                child: widget,
              ),
            ),
          ),
        ],
      );
}

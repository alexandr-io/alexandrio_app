import 'package:flutter/material.dart';

// TODO: Toggle between image sources (network, asset, ...)
class BodyBackground extends StatelessWidget {
  final Widget child;

  const BodyBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Image.asset(
          "resources/back.jpg",
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          fit: BoxFit.cover,
        ),
        Container(
          color: theme.canvasColor.withAlpha((255 * 0.5).round()),
        ),
        Material(
          color: Colors.transparent,
          child: child,
        ),
      ],
    );
  }
}

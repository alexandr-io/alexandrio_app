import 'package:flutter/material.dart';

import 'WidgetBlur.dart';

class DrawerBlur extends StatelessWidget {
  final Key key;
  final Widget child;
  final String semanticLabel;
  final double transparency;

  const DrawerBlur({
    this.key,
    @required this.child,
    this.semanticLabel,
    this.transparency: 0.75,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return WidgetBlur(
      widget: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: currentTheme.canvasColor.withAlpha((255.0 * transparency).round()),
        ),
        child: Drawer(
          child: child,
          elevation: 0.0,
          key: key,
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}

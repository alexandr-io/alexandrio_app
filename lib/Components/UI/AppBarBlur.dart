import 'dart:ui';

import 'package:flutter/material.dart';

import 'WidgetBlur.dart';

class AppBarBlur extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget appBar;
  final double transparency;
  final ThemeData theme;
  final BorderRadius borderRadius;

  const AppBarBlur({
    Key key,
    @required this.appBar,
    this.transparency: 0.75,
    this.theme,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.0),
      child: WidgetBlur(
        widget: Theme(
          data: (theme ?? currentTheme).copyWith(
            appBarTheme: currentTheme.appBarTheme.copyWith(
              color: (currentTheme.appBarTheme.color ?? currentTheme.primaryColor).withAlpha((255.0 * transparency).round()),
              elevation: 0.0,
            ),
          ),
          child: appBar,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}

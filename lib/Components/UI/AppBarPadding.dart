import 'package:flutter/material.dart';

class AppBarPadding extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget appBar;
  final EdgeInsets padding;
  final double appBarFactor;

  const AppBarPadding({
    Key key,
    @required this.appBar,
    @required this.padding,
    this.appBarFactor: 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: SafeArea(
          child: appBar,
        ),
      );

  @override
  Size get preferredSize => Size(appBar.preferredSize.width, appBar.preferredSize.height * appBarFactor + padding.collapsedSize.height);
}

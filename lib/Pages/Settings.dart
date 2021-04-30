import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/ThemeManager.dart';
import 'package:flutter_ui_tools/ThemeableMaterialApp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settingsButton),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Theme',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor.withAlpha(16),
            ),
            InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Ink(
                      width: 256,
                      height: 256,
                      child: Material(
                        child: GridView.extent(
                          maxCrossAxisExtent: 64.0,
                          children: [
                            for (var color in Colors.primaries)
                              InkWell(
                                onTap: () async {
                                  ThemeManager.of(context).lightColors.accent = color[300];
                                  ThemeManager.of(context).darkColors.accent = color[200];
                                  ThemeableMaterialApp.rebuild(context);
                                },
                                child: Ink(
                                  color: color,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Text('Color'),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Color',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          'Change the primary color of the application',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Theme.of(context).iconTheme.color,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Material(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 300,
                            child: InkWell(
                              onTap: () async => ThemeManager.of(context).mode = ThemeMode.system,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('System Theme'),
                              ),
                            ),
                          ),
                          Container(
                            width: 300,
                            child: InkWell(
                              onTap: () async => ThemeManager.of(context).mode = ThemeMode.light,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Light Theme'),
                              ),
                            ),
                          ),
                          Container(
                            width: 300,
                            child: InkWell(
                              onTap: () async => ThemeManager.of(context).mode = ThemeMode.dark,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Dark Theme'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Text('Color'),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Center(
                          child: Icon(Icons.color_lens),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Theme',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          'Select the primary style of the theme',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Theme.of(context).iconTheme.color,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

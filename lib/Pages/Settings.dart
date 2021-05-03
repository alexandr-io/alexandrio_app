import 'package:alexandrio_app/Locale/LocaleBloc.dart';
import 'package:alexandrio_app/Locale/LocaleEvent.dart';
import 'package:alexandrio_app/Locale/LocaleState.dart';
import 'package:alexandrio_app/Theme/ThemeBloc.dart';
import 'package:alexandrio_app/Theme/ThemeEvent.dart';
import 'package:alexandrio_app/Theme/ThemeState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_tools/BottomModal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleSet {
  final String locale;
  final String name;

  const LocaleSet({
    @required this.locale,
    @required this.name,
  });
}

class ThemeModeSet {
  final ThemeMode mode;
  final String name;

  const ThemeModeSet({
    @required this.mode,
    @required this.name,
  });
}

class Tile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;
  final bool dense;

  const Tile({
    Key key,
    this.onTap,
    @required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.dense = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: Theme.of(context).hintColor,
              ),
          textTheme: Theme.of(context).textTheme.copyWith(
                subtitle2: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
        ),
        child: Builder(
          builder: (context) => InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(dense ? 8.0 : 16.0),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading,
                    SizedBox(width: dense ? 8.0 : 16.0),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: dense ? 8.0 : 16.0),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settingsButton),
        ),
        body: Builder(
          builder: (context) {
            var localeSets = <LocaleSet>[
              LocaleSet(locale: null, name: AppLocalizations.of(context).localeSystemButton),
              LocaleSet(locale: 'en', name: 'English'),
              LocaleSet(locale: 'fr', name: 'Français'),
              LocaleSet(locale: 'de', name: 'Deutsch'),
            ];

            var themeModeSets = [
              ThemeModeSet(mode: ThemeMode.system, name: AppLocalizations.of(context).themeSystemButton),
              ThemeModeSet(mode: ThemeMode.dark, name: AppLocalizations.of(context).themeDarkButton),
              ThemeModeSet(mode: ThemeMode.light, name: AppLocalizations.of(context).themeLightButton),
            ];

            return ListView(
              children: [
                Tile(
                  onTap: () async => BottomModal.push(
                    context: context,
                    child: BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) => BottomModal(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var themeModeSet in themeModeSets)
                              RadioListTile(
                                value: (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded).mode == themeModeSet.mode,
                                onChanged: (value) async {
                                  BlocProvider.of<ThemeBloc>(context).add(ThemeModeChanged(mode: themeModeSet.mode));
                                  Navigator.of(context).pop();
                                },
                                groupValue: true,
                                title: Text('${themeModeSet.name}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.palette),
                  ),
                  title: AppLocalizations.of(context).themeChangeButton,
                  subtitle: themeModeSets.firstWhere((element) => (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded).mode == element.mode)?.name ?? '???',
                ),
                Tile(
                  onTap: () async => BottomModal.push(
                    context: context,
                    child: BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) => BottomModal(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var localeSet in localeSets)
                              RadioListTile(
                                value: (BlocProvider.of<LocaleBloc>(context).state as LocaleLoaded).locale == localeSet.locale,
                                onChanged: (value) async {
                                  BlocProvider.of<LocaleBloc>(context).add(LocaleChanged(localeSet.locale));
                                  Navigator.of(context).pop();
                                },
                                groupValue: true,
                                title: Text('${localeSet.name}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.language),
                  ),
                  title: AppLocalizations.of(context).localeChangeButton,
                  subtitle: localeSets.firstWhere((element) => (BlocProvider.of<LocaleBloc>(context).state as LocaleLoaded).locale == element.locale)?.name ?? '???',
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Text(
                //     'Theme',
                //     style: Theme.of(context).textTheme.headline6,
                //   ),
                // ),
                // Container(
                //   height: 1.0,
                //   color: Theme.of(context).dividerColor.withAlpha(16),
                // ),
                // InkWell(
                //   onTap: () async {
                //     await showDialog(
                //       context: context,
                //       builder: (BuildContext context) => Dialog(
                //         child: Ink(
                //           width: 256,
                //           height: 256,
                //           child: Material(
                //             child: GridView.extent(
                //               maxCrossAxisExtent: 64.0,
                //               children: [
                //                 for (var color in Colors.primaries)
                //                   InkWell(
                //                     onTap: () async {
                //                       ThemeManager.of(context).lightColors.accent = color[300];
                //                       ThemeManager.of(context).darkColors.accent = color[200];
                //                       ThemeableMaterialApp.rebuild(context);
                //                     },
                //                     child: Ink(
                //                       color: color,
                //                     ),
                //                   ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Row(
                //       children: [
                //         // Text('Color'),
                //         Padding(
                //           padding: const EdgeInsets.only(right: 12.0),
                //           child: ClipRRect(
                //             borderRadius: BorderRadius.circular(32.0),
                //             child: Container(
                //               width: 32.0,
                //               height: 32.0,
                //               color: Theme.of(context).accentColor,
                //             ),
                //           ),
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               'Color',
                //               style: Theme.of(context).textTheme.subtitle1,
                //             ),
                //             Text(
                //               'Change the primary color of the application',
                //               style: Theme.of(context).textTheme.subtitle2.copyWith(
                //                     color: Theme.of(context).iconTheme.color,
                //                   ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () async {
                //     await showDialog(
                //       context: context,
                //       builder: (BuildContext context) => Dialog(
                //         child: Material(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 width: 300,
                //                 child: InkWell(
                //                   onTap: () async => ThemeManager.of(context).mode = ThemeMode.system,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(16.0),
                //                     child: Text('System Theme'),
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 width: 300,
                //                 child: InkWell(
                //                   onTap: () async => ThemeManager.of(context).mode = ThemeMode.light,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(16.0),
                //                     child: Text('Light Theme'),
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 width: 300,
                //                 child: InkWell(
                //                   onTap: () async => ThemeManager.of(context).mode = ThemeMode.dark,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(16.0),
                //                     child: Text('Dark Theme'),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Row(
                //       children: [
                //         // Text('Color'),
                //         Padding(
                //           padding: const EdgeInsets.only(right: 12.0),
                //           child: Container(
                //             width: 32.0,
                //             height: 32.0,
                //             child: Center(
                //               child: Icon(Icons.color_lens),
                //             ),
                //           ),
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               'Theme',
                //               style: Theme.of(context).textTheme.subtitle1,
                //             ),
                //             Text(
                //               'Select the primary style of the theme',
                //               style: Theme.of(context).textTheme.subtitle2.copyWith(
                //                     color: Theme.of(context).iconTheme.color,
                //                   ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      );
}

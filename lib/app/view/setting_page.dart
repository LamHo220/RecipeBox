import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/app/app.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key, required this.action});
  final action;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>();
    return SettingsList(brightness: Brightness.light, sections: [
      SettingsSection(
        title: Text('Common'),
        tiles: <SettingsTile>[
          SettingsTile.navigation(
            leading: Icon(Icons.language),
            title: Text('Language'),
            value: Text('English'),
          ),
        ],
      ),
    ]);
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.action});
  final action;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        builder: (context, state) => SettingView(
              action: action,
            ),
        listener: (context, state) {});
  }
}

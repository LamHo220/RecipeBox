import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';

// TODO: change password
class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.action});
  final action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ThemeColors.white,
          title: Text(
            "Setting",
          ),
          titleTextStyle: Style.welcome,
          foregroundColor: ThemeColors.text,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: Pad.ptb12,
                color: ThemeColors.card,
                child: Row(
                  children: [Pad.w24, Text('Common')],
                )),
            SmartSelect.single(
              modalType: S2ModalType.bottomSheet,
              title: 'Language',
              selectedValue: 'en',
              onChange: (value) => print(value),
              choiceItems: [S2Choice(value: 'en', title: 'English')],
            ),
            SmartSelect.single(
              modalType: S2ModalType.bottomSheet,
              title: 'Theme',
              selectedValue: Brightness.light,
              onChange: (value) => print(value),
              choiceItems: [S2Choice(value: Brightness.light, title: 'Light')],
            ),
            Container(
                padding: Pad.ptb12,
                color: ThemeColors.card,
                child: Row(
                  children: [Pad.w24, Text('Account Setting')],
                )),
            TextButton(
              onPressed: () => {},
              style: TextButton.styleFrom(
                shadowColor: ThemeColors.primaryDark,
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                foregroundColor: ThemeColors.text,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () => {},
              style: TextButton.styleFrom(
                shadowColor: ThemeColors.primaryDark,
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                foregroundColor: ThemeColors.text,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Feedback',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () => {},
              style: TextButton.styleFrom(
                shadowColor: ThemeColors.primaryDark,
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                foregroundColor: ThemeColors.text,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Terms of Service',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () => {},
              style: TextButton.styleFrom(
                shadowColor: ThemeColors.primaryDark,
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                foregroundColor: ThemeColors.text,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequested());
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                shadowColor: ThemeColors.primaryDark,
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                foregroundColor: ThemeColors.text,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: const [
                  Text(
                    'Sign out',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

// class SettingPage extends StatelessWidget {
//   const SettingPage({super.key, required this.action});
//   final action;

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

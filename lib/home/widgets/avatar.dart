import 'package:flutter/material.dart';
import 'package:recipe_box/common/constants/colors.dart';

const _avatarSize = 12.0;

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.photo});

  final String? photo;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      backgroundColor: ThemeColors.inactive,
      foregroundColor: ThemeColors.white,
      radius: _avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? const Icon(
              Icons.person_outline,
              size: _avatarSize
            )
          : null,
    );
  }
}

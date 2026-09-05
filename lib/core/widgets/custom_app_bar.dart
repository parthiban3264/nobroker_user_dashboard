import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;

  final double elevation;
  final double height;

  final bool centerTitle;

  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;

  final List<Widget>? actions;
  final IconData? profileIcon;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
    this.elevation = 0,
    // this.height = kToolbarHeight,
    this.height = 58,
    this.centerTitle = false,
    this.leadingIcon,
    this.onLeadingPressed,
    this.actions,
    this.profileIcon,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      backgroundColor: backgroundColor,
      foregroundColor: iconColor,
      elevation: elevation,

      centerTitle: centerTitle,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),

      leading: leadingIcon != null
          ? IconButton(
              onPressed:
                  onLeadingPressed ??
                  () {
                    Navigator.pop(context);
                  },
              icon: Icon(leadingIcon, color: iconColor),
            )
          : profileIcon != null
          ? IconButton(
              onPressed: onProfilePressed,
              icon: Icon(profileIcon, color: iconColor),
            )
          : null,

      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

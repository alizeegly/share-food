import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.text}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final String text;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(widget.text, style: Theme.of(context).textTheme.headlineMedium),
      centerTitle: false,
      backgroundColor: colors.background,
      foregroundColor: colors.onBackground,
    );
  }
}
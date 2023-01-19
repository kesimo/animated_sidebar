import 'package:flutter/material.dart';

/// A [SidebarItem] is a Object that contains the information of a sidebar item.
/// It contains the text and the icon of the item.
/// It is used in the [AnimatedSidebar] widget. (See [AnimatedSidebar.items])
class SidebarItem {
  SidebarItem({
    required this.text,
    required this.icon,
  });

  /// The text of the item.
  final String text;

  /// The icon of the item.
  final IconData icon;
}

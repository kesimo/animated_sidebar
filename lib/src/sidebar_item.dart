import 'package:flutter/material.dart';

/// A [SidebarItem] is a Object that contains the information of a sidebar item.
/// It contains the text and the icon of the item.
/// Possible to add child items to the item and make it expanding.
/// It is used in the [AnimatedSidebar] widget. (See [AnimatedSidebar.items])
class SidebarItem {
  SidebarItem({
    required this.text,
    required this.icon,
    this.children = const [],
  });

  /// The text of the item.
  final String text;

  /// The icon of the item.
  final IconData icon;

  /// The optional child items of the item.
  final List<SidebarChildItem> children;
}

/// A [SidebarChildItem] is a Object that contains the information of a sidebar item.
/// It contains the text and the icon of the item and should only be used as a child of a [SidebarItem].
/// It is used in the [AnimatedSidebar] widget. (See [AnimatedSidebar.items])
class SidebarChildItem {
  SidebarChildItem({
    required this.text,
    required this.icon,
  });

  /// The text of the item.
  final String text;

  /// The icon of the item.
  final IconData icon;
}

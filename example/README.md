# Animated Sidebar

A highly customizable and styleable collapsable sidebar plugin for Flutter, optimized for web and desktop applications.

## Example

<video width="320" height="240" controls>
  <source src="./media/example.mov" type="video/mp4">
</video>

## Installation

Add the following to your pubspec.yaml file:

```bash
dependencies:
  animated_sidebar: ^0.0.1
```

or use the following command:

```bash
flutter pub add animated_sidebar
```

Add the following import to your dart file:

```dart
import 'package:animated_sidebar/animated_sidebar.dart';
```

## Usage

define a list of `SidebarItem` objects:

```dart
  import 'package:animated_sidebar/animated_sidebar.dart';

  final List<SidebarItem> items = [
    SidebarItem(
      icon: Icons.home,
      text: 'Home',
    ),
    SidebarItem(
      icon: Icons.notification_important_rounded,
      text: 'Notifications',
    ),
    SidebarItem(
      icon: Icons.person,
      text: 'Management',
    ),
    SidebarItem(
      icon: Icons.abc,
      text: 'Integrations',
    ),
    SidebarItem(
      icon: Icons.settings,
      text: 'Settings',
    ),
  ];

```

use the `AnimatedSidebar` widget:

```dart
  import 'package:animated_sidebar/animated_sidebar.dart';

  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          AnimatedSidebar(
            expanded: MediaQuery.of(context).size.width > 600,
            items: items,
            selectedIndex: activeTab,
            onItemSelected: (index) =>
                setState(() => activeTab = index),
            headerIcon: Icons.ac_unit_sharp,
            headerIconColor: Colors.amberAccent,
            headerText: 'Example',
          ),
          Center(
            child: Text(
              'Page: $activeTab',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
      ),
    );
  }
```

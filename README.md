
# Animated Sidebar

[![pub package](https://img.shields.io/pub/v/animated_sidebar.svg?style=flat-square)](https://pub.dev/packages/animated_sidebar)
[![Libraries.io for GitHub](https://img.shields.io/librariesio/github/kesimo/animated_sidebar.svg?style=flat-square)](https://libraries.io/github/kesimo/animated_sidebar) 
[![License](https://img.shields.io/badge/License-MIT%20-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A highly customizable and styleable collapsable sidebar plugin for Flutter, optimized for web and desktop applications.

## Example

![example-ui](https://github.com/kesimo/animated_sidebar/blob/main/media/example.gif)

## Installation

Add the following to your pubspec.yaml file:

```bash  
dependencies:  
 animated_sidebar: ^1.0.0   
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

### Sidebar Items
define a list of `SidebarItem` objects:

```dart  
import 'package:animated_sidebar/animated_sidebar.dart';  
  
final List<SidebarItem> items = [  
  SidebarItem(icon: Icons.home, text: 'Home'),  
  SidebarItem(icon: Icons.notifications, text: 'Notifications'),  
  SidebarItem(icon: Icons.person, text: 'Management'),  
];  
```

### Child Items
it is also possible to define multiple `SidebarChildItem` for every `SidebarItem`.

```dart  
import 'package:animated_sidebar/animated_sidebar.dart';  
  
final List<SidebarItem> items = [  
  SidebarItem(icon: Icons.home, text: 'Home'),  
  SidebarItem(  
    icon: Icons.person,  
    text: 'Management',  
    children: [  
	  SidebarChildItem(icon: Icons.person, text: 'Users'),  
	  SidebarChildItem(icon: Icons.verified_user, text: 'Roles'),  
    ],  
  ),
];  
```
The Item Containing the Children is Collapsed and expand only on tap. If the Current selected item is a `SidebarChildItem` the overlying Item keeps expanded


### Default usage of `AnimatedSidebar`

```dart
import 'package:animated_sidebar/animated_sidebar.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: Row(
      children: [
        AnimatedSidebar(
          expanded: MediaQuery.of(context).size.width > 600,
          items: items,
          selectedIndex: 0,
          onItemSelected: (index) => print(index),
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


### Use the `AnimatedSidebar` widget and *handle state external* :

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
          autoSelectedIndex: false, // must be false if you want to handle state external
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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_sidebar/animated_sidebar.dart';

void main() {
  // predefine items
  List<SidebarItem> items() => [
        SidebarItem(
          icon: Icons.home,
          text: 'Home',
        ),
        SidebarItem(
          icon: Icons.notification_important_rounded,
          text: 'Notifications', //global variables, properties, etc.
        ),
        SidebarItem(
          icon: Icons.person,
          text: 'Management', //api, tokens, users, access rules etc.
        ),
        SidebarItem(
          icon: Icons.abc,
          text: 'Integrations', //api, tokens, users, access rules etc.
        ),
        SidebarItem(
          icon: Icons.settings,
          text: 'Settings', //api, tokens, users, access rules etc.
        ),
      ];

  // test sidebar widget
  testWidgets('Sidebar widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return Scaffold(
            body: Container(
              margin: const EdgeInsets.fromLTRB(16, 24, 0, 24),
              child: AnimatedSidebar(
                expanded: true,
                items: items(),
                selectedIndex: 0,
                onItemSelected: (index) => {},
                duration: const Duration(milliseconds: 250),
                minSize: 90,
                maxSize: 250,
                itemIconSize: 26,
                itemIconColor: Colors.white,
                itemHoverColor: Colors.grey.withOpacity(0.3),
                itemSelectedColor: Colors.grey,
                itemSelectedBorder: const BorderRadius.all(
                  Radius.circular(5),
                ),
                itemMargin: 16,
                itemSpaceBetween: 10,
                headerIcon: Icons.menu,
                headerIconSize: 30,
                headerIconColor: Colors.deepPurple,
                headerTextStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                headerText: ' TimeTasks',
              ),
            ),
          );
        },
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Management'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Integrations'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

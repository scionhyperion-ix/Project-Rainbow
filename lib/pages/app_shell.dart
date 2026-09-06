import 'package:flutter/material.dart';

import '../widgets/floating_bottom_nav.dart';
import 'home_page.dart';
import 'journal_page.dart';
import 'members_page.dart';
import 'settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _openMembers() {
    setState(() => _index = 1);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOpenMembers: _openMembers),
      const MembersPage(),
      const JournalPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: FloatingBottomNav(
        index: _index,
        onChanged: (value) => setState(() => _index = value),
      ),
    );
  }
}

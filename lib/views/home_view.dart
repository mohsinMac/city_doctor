import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/navigation_viewmodel.dart';
import '../models/auth_state.dart';
import 'login_screen.dart';
import 'home_tab_view.dart';
import 'chat_tab_view.dart';
import 'notifications_tab_view.dart';
import 'profile_tab_view.dart';

class BaseScreen extends ConsumerWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch navigation state
    final currentIndex = ref.watch(navigationViewModelProvider);
    final navigationViewModel = ref.read(navigationViewModelProvider.notifier);

    // Listen for auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next is AuthUnauthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    final List<Widget> pages = [
      const HomeTabView(),
      const ChatTabView(),
      const NotificationsTabView(),
      const ProfileTabView(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          navigationViewModel.setCurrentIndex(index);
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
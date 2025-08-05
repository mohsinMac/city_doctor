import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/widgets.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/app_theme.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(currentThemeProvider);
    final themeNotifier = ref.read(themeViewModelProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            AppCard(
              child: Column(
                children: [
                  AppInfoCard(
                    title: 'Theme',
                    subtitle: 'Choose your preferred theme',
                    icon: const Icon(Icons.palette),
                    onTap: () => _showThemeSelector(context, ref),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.color_lens),
                        const SizedBox(width: 12),
                        Text(
                          'Current: ${themeNotifier.themeName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(themeNotifier.primaryColorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Account Section
            Text(
              'Account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            AppCard(
              child: Column(
                children: [
                  AppInfoCard(
                    title: currentUser?.name ?? 'User',
                    subtitle: currentUser?.email ?? 'No email',
                    icon: const Icon(Icons.account_circle),
                  ),
                  const Divider(height: 1),
                  AppInfoCard(
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    icon: const Icon(Icons.edit),
                    onTap: () {
                      AppSnackBar.showInfo(
                        context,
                        message: 'Edit profile feature coming soon!',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  AppInfoCard(
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    icon: const Icon(Icons.lock),
                    onTap: () {
                      AppSnackBar.showInfo(
                        context,
                        message: 'Change password feature coming soon!',
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Section
            Text(
              'App Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            AppCard(
              child: Column(
                children: [
                  AppInfoCard(
                    title: 'Version',
                    subtitle: '1.0.0',
                    icon: const Icon(Icons.info),
                  ),
                  const Divider(height: 1),
                  AppInfoCard(
                    title: 'About',
                    subtitle: 'Learn more about City Doctor',
                    icon: const Icon(Icons.help),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  AppInfoCard(
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    icon: const Icon(Icons.privacy_tip),
                    onTap: () {
                      AppSnackBar.showInfo(
                        context,
                        message: 'Privacy policy feature coming soon!',
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            AppButton(
              text: 'Logout',
              onPressed: () => _showLogoutDialog(context, ref),
              backgroundColor: Colors.red,
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(currentThemeProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF0165FC),
                  shape: BoxShape.circle,
                ),
              ),
              title: const Text('Primary Blue'),
              trailing: currentTheme == AppThemeMode.primaryBlue
                  ? const Icon(Icons.check_circle, color: Color(0xFF0165FC))
                  : null,
              onTap: () {
                ref.read(themeViewModelProvider.notifier).setPrimaryBlueTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
              ),
              title: const Text('Medical Green'),
              trailing: currentTheme == AppThemeMode.medicalGreen
                  ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32))
                  : null,
              onTap: () {
                ref.read(themeViewModelProvider.notifier).setMedicalGreenTheme();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About City Doctor'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'City Doctor is a comprehensive healthcare management app designed to make healthcare accessible and convenient.',
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('• Find nearby doctors'),
            Text('• Book appointments'),
            Text('• Track medications'),
            Text('• Manage health records'),
            Text('• Emergency services'),
            SizedBox(height: 16),
            Text(
              'Built with Flutter and Riverpod',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authViewModelProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        children: [
          // User Info
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: AppTypography.headingLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Settings
          _SectionTitle(title: 'Settings', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [

              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
                isDark: isDark,
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account
          _SectionTitle(title: 'Account', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [
              _SettingsTile(
                icon: Icons.receipt_outlined,
                title: 'Order History',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/orders');
                },
                isDark: isDark,
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.favorite_outline,
                title: 'Favorites',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
                isDark: isDark,
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/addresses');
                },
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Support
          _SectionTitle(title: 'Support', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsCard(
            isDark: isDark,
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
                isDark: isDark,
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Next Organics',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024 Next Organics',
                  );
                },
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Logout
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                        context.go('/onboarding');
                      },
                      child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.headingSmall.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

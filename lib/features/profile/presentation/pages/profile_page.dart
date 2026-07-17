import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/app_breakpoints.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/section_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Abas Ashkar',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 2),
                        Text(
                          'Media Alacarte · Ad Ops',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'Appearance'),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  final isDark = mode == ThemeMode.dark;
                  return AppCard(
                    child: Row(
                      children: [
                        Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text('Dark mode',
                              style: theme.textTheme.titleMedium),
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (_) =>
                              context.read<ThemeCubit>().toggle(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'About'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: const [
                    _AboutRow(
                      icon: Icons.info_outline_rounded,
                      label: 'Version',
                      value: '1.0.0',
                    ),
                    Divider(height: AppSpacing.xl),
                    _AboutRow(
                      icon: Icons.api_rounded,
                      label: 'Data source',
                      value: 'Ads Mock API',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

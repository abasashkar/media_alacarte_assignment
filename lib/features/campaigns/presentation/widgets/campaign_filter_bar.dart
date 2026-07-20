import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/campaign_status.dart';

/// Search field plus status filter chips (All / Active / Paused) for the list.
class CampaignFilterBar extends StatelessWidget {
  const CampaignFilterBar({
    super.key,
    required this.filter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final CampaignStatus? filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<CampaignStatus?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search campaigns...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip(context, label: 'All', value: null),
              const SizedBox(width: AppSpacing.md),
              _chip(context, label: 'Active', value: CampaignStatus.active),
              const SizedBox(width: AppSpacing.md),
              _chip(context, label: 'Paused', value: CampaignStatus.paused),
              const SizedBox(width: AppSpacing.md),
              _chip(context, label: 'Ended', value: CampaignStatus.ended),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required CampaignStatus? value,
  }) {
    final selected = filter == value;
    // A subtle lift so the active chip feels raised above the rest.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        labelStyle: TextStyle(
          color: selected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => onFilterChanged(value),
      ),
    );
  }
}

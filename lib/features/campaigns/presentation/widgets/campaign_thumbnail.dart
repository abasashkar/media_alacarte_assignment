import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Rounded teal tile with an icon derived from the campaign objective/channel.
/// Falls back to an icon when no thumbnail is available.
class CampaignThumbnail extends StatelessWidget {
  const CampaignThumbnail({
    super.key,
    required this.objective,
    required this.channel,
    this.size = 44,
  });

  final String objective;
  final String channel;
  final double size;

  IconData get _icon {
    final key = '$objective $channel'.toLowerCase();
    if (key.contains('conversion')) return Icons.shopping_cart_rounded;
    if (key.contains('awareness')) return Icons.campaign_rounded;
    if (key.contains('social')) return Icons.groups_rounded;
    if (key.contains('search')) return Icons.search_rounded;
    if (key.contains('display')) return Icons.image_rounded;
    return Icons.trending_up_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.28),
            AppColors.accentB.withValues(alpha: 0.14),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Icon(_icon, color: AppColors.primary, size: size * 0.5),
    );
  }
}

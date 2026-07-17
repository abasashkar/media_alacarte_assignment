import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/anomalies/presentation/pages/anomaly_page.dart';
import '../../features/campaigns/presentation/pages/campaign_detail_page.dart';
import '../../features/campaigns/presentation/pages/campaign_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/spend_summary/presentation/pages/spend_summary_page.dart';
import 'app_routes.dart';

/// Builds the app's [GoRouter] with a bottom-nav shell and nested detail route.
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.campaigns,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.campaigns,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CampaignListPage(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoutes.campaignDetail,
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => CampaignDetailPage(
                      campaignId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.spendSummary,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SpendSummaryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.alerts,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AnomalyPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

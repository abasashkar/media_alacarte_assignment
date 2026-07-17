import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/service_locator.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await sl<NotificationService>().init();
  runApp(const AdCampaignApp());
}

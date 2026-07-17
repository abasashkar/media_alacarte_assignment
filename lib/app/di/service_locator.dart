import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/dio_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/theme_cubit.dart';
import '../../features/anomalies/data/datasources/anomaly_remote_data_source.dart';
import '../../features/anomalies/data/repositories/anomaly_repository_impl.dart';
import '../../features/anomalies/domain/repositories/anomaly_repository.dart';
import '../../features/anomalies/presentation/bloc/anomaly_bloc.dart';
import '../../features/campaigns/data/datasources/campaign_local_data_source.dart';
import '../../features/campaigns/data/datasources/campaign_remote_data_source.dart';
import '../../features/campaigns/data/repositories/campaign_repository_impl.dart';
import '../../features/campaigns/domain/repositories/campaign_repository.dart';
import '../../features/campaigns/presentation/bloc/campaign_detail/campaign_detail_bloc.dart';
import '../../features/campaigns/presentation/bloc/campaign_list/campaign_list_bloc.dart';
import '../../features/spend_summary/data/datasources/spend_remote_data_source.dart';
import '../../features/spend_summary/data/repositories/spend_repository_impl.dart';
import '../../features/spend_summary/domain/repositories/spend_repository.dart';
import '../../features/spend_summary/presentation/bloc/spend_summary_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers all dependencies. Call once during app bootstrap.
Future<void> setupServiceLocator() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // Data sources
  sl.registerLazySingleton<CampaignRemoteDataSource>(
    () => CampaignRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CampaignLocalDataSource>(
    () => CampaignLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SpendRemoteDataSource>(
    () => SpendRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AnomalyRemoteDataSource>(
    () => AnomalyRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(remote: sl(), local: sl()),
  );
  sl.registerLazySingleton<SpendRepository>(
    () => SpendRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AnomalyRepository>(
    () => AnomalyRepositoryImpl(sl()),
  );

  // Blocs (factories - a fresh instance per screen)
  sl.registerFactory<CampaignListBloc>(() => CampaignListBloc(sl()));
  sl.registerFactory<CampaignDetailBloc>(() => CampaignDetailBloc(sl()));
  sl.registerFactory<SpendSummaryBloc>(() => SpendSummaryBloc(sl()));
  sl.registerFactory<AnomalyBloc>(
    () => AnomalyBloc(repository: sl(), notifications: sl()),
  );
}

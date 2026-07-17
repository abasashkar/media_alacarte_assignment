import 'package:ad_campaign_dashboard/core/error/failure.dart';
import 'package:ad_campaign_dashboard/core/network/api_exception.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/datasources/campaign_local_data_source.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/datasources/campaign_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/models/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/models/campaign_status.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/repositories/campaign_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements CampaignRemoteDataSource {}

class _MockLocal extends Mock implements CampaignLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late CampaignRepositoryImpl repository;

  const campaign = Campaign(
    id: 'camp_001',
    name: 'Ramadan Mega Sale',
    status: CampaignStatus.active,
    objective: 'Conversion',
    channel: 'Social',
    budget: 50000,
    spend: 34200,
    impressions: 1840000,
    clicks: 73600,
    ctr: 0.04,
    budgetUtilization: 68.4,
    currency: 'SAR',
  );

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = CampaignRepositoryImpl(remote: remote, local: local);
  });

  group('getCampaigns', () {
    test('returns campaigns and caches them on success', () async {
      when(() => remote.getCampaigns())
          .thenAnswer((_) async => [campaign]);
      when(() => local.cacheCampaigns(any())).thenAnswer((_) async {});

      final result = await repository.getCampaigns();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [campaign]);
      verify(() => local.cacheCampaigns([campaign])).called(1);
    });

    test('falls back to cache when the remote call fails', () async {
      when(() => remote.getCampaigns())
          .thenThrow(const ApiException('offline'));
      when(() => local.getCachedCampaigns()).thenReturn([campaign]);

      final result = await repository.getCampaigns();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [campaign]);
    });

    test('returns a Failure when remote fails and no cache exists', () async {
      when(() => remote.getCampaigns()).thenThrow(
        const ApiException('boom', type: ApiExceptionType.network),
      );
      when(() => local.getCachedCampaigns()).thenReturn(null);

      final result = await repository.getCampaigns();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected a Failure'),
      );
    });
  });
}

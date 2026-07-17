import 'package:ad_campaign_dashboard/core/error/failure.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/models/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/models/campaign_status.dart';
import 'package:ad_campaign_dashboard/features/campaigns/domain/repositories/campaign_repository.dart';
import 'package:ad_campaign_dashboard/features/campaigns/presentation/bloc/campaign_list/campaign_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCampaignRepository extends Mock implements CampaignRepository {}

Campaign _campaign(String id, String name, CampaignStatus status) => Campaign(
      id: id,
      name: name,
      status: status,
      objective: 'Conversion',
      channel: 'Social',
      budget: 1000,
      spend: 500,
      impressions: 100,
      clicks: 5,
      ctr: 0.05,
      budgetUtilization: 50,
      currency: 'SAR',
    );

void main() {
  late CampaignRepository repository;

  final campaigns = [
    _campaign('1', 'Ramadan Sale', CampaignStatus.active),
    _campaign('2', 'Winter Paused', CampaignStatus.paused),
  ];

  setUp(() => repository = _MockCampaignRepository());

  blocTest<CampaignListBloc, CampaignListState>(
    'emits [loading, success] when campaigns load',
    build: () {
      when(() => repository.getCampaigns())
          .thenAnswer((_) async => Right(campaigns));
      return CampaignListBloc(repository);
    },
    act: (bloc) => bloc.add(const CampaignListRequested()),
    expect: () => [
      isA<CampaignListState>()
          .having((s) => s.status, 'status', CampaignListStatus.loading),
      isA<CampaignListState>()
          .having((s) => s.status, 'status', CampaignListStatus.success)
          .having((s) => s.campaigns.length, 'count', 2),
    ],
  );

  blocTest<CampaignListBloc, CampaignListState>(
    'emits [loading, failure] when the repository fails',
    build: () {
      when(() => repository.getCampaigns())
          .thenAnswer((_) async => const Left(NetworkFailure()));
      return CampaignListBloc(repository);
    },
    act: (bloc) => bloc.add(const CampaignListRequested()),
    expect: () => [
      isA<CampaignListState>()
          .having((s) => s.status, 'status', CampaignListStatus.loading),
      isA<CampaignListState>()
          .having((s) => s.status, 'status', CampaignListStatus.failure),
    ],
  );

  blocTest<CampaignListBloc, CampaignListState>(
    'filters by status and search query',
    build: () {
      when(() => repository.getCampaigns())
          .thenAnswer((_) async => Right(campaigns));
      return CampaignListBloc(repository);
    },
    act: (bloc) => bloc
      ..add(const CampaignListRequested())
      ..add(const CampaignFilterChanged(CampaignStatus.paused)),
    verify: (bloc) {
      expect(bloc.state.filteredCampaigns.length, 1);
      expect(bloc.state.filteredCampaigns.first.name, 'Winter Paused');
    },
  );
}

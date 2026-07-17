import 'package:equatable/equatable.dart';

/// Targeting details shown on the campaign detail screen.
class TargetAudience extends Equatable {
  const TargetAudience({
    required this.ageRange,
    required this.regions,
    required this.interests,
  });

  final String ageRange;
  final List<String> regions;
  final List<String> interests;

  factory TargetAudience.fromJson(Map<String, dynamic> json) {
    return TargetAudience(
      ageRange: json['age_range'] as String? ?? '',
      regions: (json['regions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      interests: (json['interests'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  @override
  List<Object?> get props => [ageRange, regions, interests];
}

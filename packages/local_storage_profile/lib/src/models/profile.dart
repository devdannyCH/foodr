import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:snaq_api/snaq_api.dart';

part 'profile.g.dart';

/// {@template profile}
///  Profile representating user preferences that will filter meals
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Profile extends Equatable {
  /// {@macro Profile}
  const Profile({
    required this.energyThreshold,
    required this.bannedIngredients,
  });

  /// Max energy threshold
  static const double maxEnergyThreshold = 2000;

  /// Min energy threshold
  static const double minEnergyThreshold = 0;

  /// Max energy (calorie) limit for displayed meals
  final double energyThreshold;

  /// Banned ingredients that must not be included in displayed meals
  final Set<Ingredient> bannedIngredients;

  /// Deserializes the given [JsonMap] into a [Profile].
  static Profile fromJson(JsonMap json) => _$ProfileFromJson(json);

  /// Converts this [Profile] into a [JsonMap].
  JsonMap toJson() => _$ProfileToJson(this);

  @override
  List<Object?> get props => [energyThreshold, bannedIngredients];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      energyThreshold: json['energyThreshold'] as double,
      bannedIngredients: (json['bannedIngredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'energyThreshold': instance.energyThreshold,
      'bannedIngredients':
          instance.bannedIngredients.map((e) => e.toJson()).toList(),
    };

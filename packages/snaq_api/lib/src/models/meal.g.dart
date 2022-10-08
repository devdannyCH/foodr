// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      id: json['id'] as String,
      created: json['created'] as String,
      image: json['image'] as String,
      nutrition: Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
      mealComponents: (json['mealComponents'] as List<dynamic>)
          .map((e) => MealComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'image': instance.image,
      'nutrition': instance.nutrition.toJson(),
      'mealComponents': instance.mealComponents.map((e) => e.toJson()).toList(),
    };

MealComponent _$MealComponentFromJson(Map<String, dynamic> json) =>
    MealComponent(
      mainIngredient: json['mainIngredient'] == null
          ? null
          : Ingredient.fromJson(json['mainIngredient'] as Map<String, dynamic>),
      supplementaryIngredients:
          (json['supplementaryIngredients'] as List<dynamic>)
              .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$MealComponentToJson(MealComponent instance) =>
    <String, dynamic>{
      'mainIngredient': instance.mainIngredient?.toJson(),
      'supplementaryIngredients':
          instance.supplementaryIngredients.map((e) => e.toJson()).toList(),
    };

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      name: json['name'] as String,
      nutrition: Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nutrition': instance.nutrition.toJson(),
    };

Nutrition _$NutritionFromJson(Map<String, dynamic> json) => Nutrition(
      carbohydrates: NutritionComponent.fromJson(
          json['carbohydrates'] as Map<String, dynamic>),
      fatTotal:
          NutritionComponent.fromJson(json['fatTotal'] as Map<String, dynamic>),
      protein:
          NutritionComponent.fromJson(json['protein'] as Map<String, dynamic>),
      energy:
          NutritionComponent.fromJson(json['energy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NutritionToJson(Nutrition instance) => <String, dynamic>{
      'carbohydrates': instance.carbohydrates.toJson(),
      'fatTotal': instance.fatTotal.toJson(),
      'protein': instance.protein.toJson(),
      'energy': instance.energy.toJson(),
    };

NutritionComponent _$NutritionComponentFromJson(Map<String, dynamic> json) =>
    NutritionComponent(
      name: $enumDecode(_$NameEnumMap, json['name']),
      unit: $enumDecode(_$UnitEnumMap, json['unit']),
      value: json['value'] as int,
      valueWithPrecision: (json['valueWithPrecision'] as num).toDouble(),
      abbreviation:
          Abbreviation.fromJson(json['abbreviation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NutritionComponentToJson(NutritionComponent instance) =>
    <String, dynamic>{
      'name': _$NameEnumMap[instance.name]!,
      'unit': _$UnitEnumMap[instance.unit]!,
      'value': instance.value,
      'valueWithPrecision': instance.valueWithPrecision,
      'abbreviation': instance.abbreviation.toJson(),
    };

const _$NameEnumMap = {
  Name.carbohydrates: 'Carbohydrates',
  Name.calories: 'Calories',
  Name.fats: 'Fats',
  Name.protein: 'Protein',
};

const _$UnitEnumMap = {
  Unit.gram: 'Gram',
  Unit.kilocalories: 'Kilocalories',
};

Abbreviation _$AbbreviationFromJson(Map<String, dynamic> json) => Abbreviation(
      unit: $enumDecode(_$AbbreviationUnitEnumMap, json['unit']),
      nutrient: $enumDecode(_$NutrientEnumMap, json['nutrient']),
    );

Map<String, dynamic> _$AbbreviationToJson(Abbreviation instance) =>
    <String, dynamic>{
      'unit': _$AbbreviationUnitEnumMap[instance.unit]!,
      'nutrient': _$NutrientEnumMap[instance.nutrient]!,
    };

const _$AbbreviationUnitEnumMap = {
  AbbreviationUnit.g: 'g',
  AbbreviationUnit.kcal: 'kcal',
};

const _$NutrientEnumMap = {
  Nutrient.carbs: 'Carbs',
  Nutrient.kcal: 'kcal',
  Nutrient.fat: 'Fat',
  Nutrient.protein: 'Protein',
};

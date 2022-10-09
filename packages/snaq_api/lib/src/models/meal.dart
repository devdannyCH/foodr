import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:snaq_api/src/models/json_map.dart';

part 'meal.g.dart';

/// {@template meal}
/// A model containing data about a meal.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Meal extends Equatable {
  /// {@macro meal}
  Meal({
    required this.id,
    required this.created,
    required this.image,
    required this.nutrition,
    required this.mealComponents,
    MealStatus? status,
  }) : status = status ?? MealStatus.stacked;

  /// The ID of the meal
  final String id;

  /// The timestamp of the meal
  final String created;

  /// A picture of the meal
  final String image;

  /// Nutritional information (carbs, fats, proteins & calories) about the meal
  final Nutrition nutrition;

  /// List of ingredients composing the meal
  final List<MealComponent> mealComponents;

  @JsonKey(defaultValue: MealStatus.stacked)

  /// Current meal status (stacked, liked, disliked)
  MealStatus status;

  /// Deserializes the given [JsonMap] into a [Meal].
  static Meal fromJson(JsonMap json) => _$MealFromJson(json);

  /// Converts this [Meal] into a [JsonMap].
  JsonMap toJson() => _$MealToJson(this);

  @override
  List<Object> get props => [id];
}

@JsonSerializable(explicitToJson: true)

/// {@template meal}
/// A model containing data about a meal component.
/// {@endtemplate}
class MealComponent {
  /// {@macro mealComponent}
  const MealComponent({
    this.mainIngredient,
    required this.supplementaryIngredients,
  });

  /// The main ingredient of the meal component
  final Ingredient? mainIngredient;

  /// List of supplementary ingredients of the meal component
  final List<Ingredient> supplementaryIngredients;

  /// Deserializes the given [JsonMap] into a [MealComponent].
  static MealComponent fromJson(JsonMap json) => _$MealComponentFromJson(json);

  /// Converts this [MealComponent] into a [JsonMap].
  JsonMap toJson() => _$MealComponentToJson(this);
}

@JsonSerializable(explicitToJson: true)

/// {@template meal}
/// A model containing data about a ingredient.
/// {@endtemplate}
class Ingredient {
  /// {@macro ingredient}
  const Ingredient({
    required this.name,
    required this.nutrition,
  });

  /// The name of the ingredient
  final String name;

  /// The nutrional information about the ingredient
  final Nutrition nutrition;

  /// Deserializes the given [JsonMap] into a [Ingredient].
  static Ingredient fromJson(JsonMap json) => _$IngredientFromJson(json);

  /// Converts this [Ingredient] into a [JsonMap].
  JsonMap toJson() => _$IngredientToJson(this);
}

@JsonSerializable(explicitToJson: true)

/// {@template meal}
/// A model containing data about nutritional information.
/// {@endtemplate}
class Nutrition {
  /// {@macro ingredient}
  const Nutrition({
    required this.carbohydrates,
    required this.fatTotal,
    required this.protein,
    required this.energy,
  });

  /// The carbohydrates information about a meal or meal component
  final NutritionComponent carbohydrates;

  /// The fats information about a meal or meal component
  final NutritionComponent fatTotal;

  /// The protein information about a meal or meal component
  final NutritionComponent protein;

  /// The energy information about a meal or meal component
  final NutritionComponent energy;

  /// Deserializes the given [JsonMap] into a [Nutrition].
  static Nutrition fromJson(JsonMap json) => _$NutritionFromJson(json);

  /// Converts this [Nutrition] into a [JsonMap].
  JsonMap toJson() => _$NutritionToJson(this);
}

@JsonSerializable(explicitToJson: true)

/// {@template meal}
/// A model containing data about a nutrition component.
/// {@endtemplate}
class NutritionComponent {
  /// {@macro nutritionComponent}
  const NutritionComponent({
    required this.name,
    required this.unit,
    required this.value,
    required this.valueWithPrecision,
    required this.abbreviation,
  });

  /// The name of the nutrition component
  final Name name;

  /// The unit of the nutrition component
  final Unit unit;

  /// The rounded value of the nutrition component
  final int value;

  /// The precise value of the nutrition component
  final double valueWithPrecision;

  /// The abbreviation for this nutrition component
  final Abbreviation abbreviation;

  /// Deserializes the given [JsonMap] into a [NutritionComponent].
  static NutritionComponent fromJson(JsonMap json) =>
      _$NutritionComponentFromJson(json);

  /// Converts this [NutritionComponent] into a [JsonMap].
  JsonMap toJson() => _$NutritionComponentToJson(this);

  @override
  String toString() {
    if (unit == Unit.kilocalories) {
      return '$value ${abbreviation.unit.name}';
    } else {
      return '${abbreviation.nutrient.name}: $value${abbreviation.unit.name}';
    }
  }
}

@JsonSerializable(explicitToJson: true)

/// {@template meal}
/// A model containing data about an unit abbreviation.
/// {@endtemplate}
class Abbreviation {
  /// {@macro abbreviation}
  const Abbreviation({
    required this.unit,
    required this.nutrient,
  });

  /// The unit abbreviation used
  final AbbreviationUnit unit;

  /// The type of nutrtient
  final Nutrient nutrient;

  /// Deserializes the given [JsonMap] into a [Abbreviation].
  static Abbreviation fromJson(JsonMap json) => _$AbbreviationFromJson(json);

  /// Converts this [NutritionComponent] into a [Abbreviation].
  JsonMap toJson() => _$AbbreviationToJson(this);
}

@JsonEnum()

/// {@template meal}
/// A enum containing different types of nutrients.
/// {@endtemplate}
enum Nutrient {
  /// Carbohydrates
  @JsonValue('Carbs')
  carbs,

  /// Kilocalories
  kcal,

  /// Fat
  @JsonValue('Fat')
  fat,

  /// Protein
  @JsonValue('Protein')
  protein,
}

@JsonEnum()

/// {@template meal}
/// A enum containing different types of nutrients.
/// {@endtemplate}
enum AbbreviationUnit {
  /// Gram
  g,

  /// Kilocalories
  kcal,
}

@JsonEnum()

/// {@template meal}
/// A enum containing names of nutrition component.
/// {@endtemplate}
enum Name {
  /// Carbohydrates
  @JsonValue('Carbohydrates')
  carbohydrates,

  /// Calories
  @JsonValue('Calories')
  calories,

  /// Fats
  @JsonValue('Fats')
  fats,

  /// Protein
  @JsonValue('Protein')
  protein,
}

@JsonEnum()

/// {@template meal}
/// A enum containing measurement units
/// {@endtemplate}
enum Unit {
  /// g
  @JsonValue('Gram')
  gram,

  /// kcal
  @JsonValue('Kilocalories')
  kilocalories,
}

@JsonEnum()

/// {@template meal}
/// A enum containing meal status
/// {@endtemplate}
enum MealStatus {
  /// Displayed in the stack
  stacked,

  /// Liked
  liked,

  /// Disliked
  disliked,
}

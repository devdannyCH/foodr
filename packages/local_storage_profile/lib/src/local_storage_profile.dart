// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:local_storage_profile/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snaq_api/snaq_api.dart';

/// Key to access profile in SharedPreferences
const String profileKey = 'profileKey';

/// Default profile
const Profile _defaultProfile = Profile(
  energyThreshold: Profile.maxEnergyThreshold,
  bannedIngredients: <Ingredient>{},
);

/// {@template local_storage_profile}
/// Local storage of profile
/// {@endtemplate}
class LocalStorageProfile {
  /// {@macro local_storage_profile}
  LocalStorageProfile();

  /// Store the profile in SharedPreferences
  Future<void> storeProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileKey, jsonEncode(profile.toJson()));
  }

  /// Get the profile from SharedPreferences
  Future<Profile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(profileKey);
    if (profileStr != null) {
      return Profile.fromJson(jsonDecode(profileStr) as Map<String, dynamic>);
    } else {
      return _defaultProfile;
    }
  }
}

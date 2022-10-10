// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:local_storage_profile/local_storage_profile.dart';

/// Thrown when an error occurs while looking up profile.
class ProfileException implements Exception {}

/// {@template profile_repository}
/// A repository that handles profile related requests
/// {@endtemplate}
class ProfileRepository {
  /// {@macro profile_repository}
  ProfileRepository({
    LocalStorageProfile? localStorageProfile,
  }) : _localStorageProfile = localStorageProfile ?? LocalStorageProfile();

  final LocalStorageProfile _localStorageProfile;

  /// Returns the user profile
  ///
  /// Throws a [ProfileException] if an error occurs.
  Future<Profile> getProfile() async {
    try {
      final profile = await _localStorageProfile.getProfile();
      return profile;
    } on Exception {
      throw ProfileException();
    }
  }

  /// Update user profile
  ///
  /// Throws a [ProfileException] if an error occurs.
  Future<void> updateProfile(Profile profile) async {
    try {
      await _localStorageProfile.storeProfile(profile);
    } on Exception {
      throw ProfileException();
    }
  }
}

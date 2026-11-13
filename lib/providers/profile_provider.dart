import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/faqs_model.dart';
import '../models/profile_details_model.dart';
import '../network/api_services.dart';
import '../network/api_urls.dart';
import '../utils/async_notifier.dart';

part 'profile_provider.g.dart';

@riverpod
class Profile extends _$Profile {
  @override
  AsyncState<ProfileModel> build() {
    return const AsyncState();
  }

  Future<void> getProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.get(
        ApiEndpoints.profile,
        requireAuth: true,
      );

      if (!ref.mounted) return;

      final response = ProfileResponse.fromJson(res.data as Map<String, dynamic>);

      state = state.copyWith(
        isLoading: false,
        data: response.data,
        error: null,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> uploadProfilePic(File imageFile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final res = await api.post(
        ApiEndpoints.updateProfilePicture,
        requireAuth: true,
        data: formData,
        contentType: 'multipart/form-data',
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile picture updated successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to upload profile picture: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required int age,
    required String gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.put(
        ApiEndpoints.updateProfile,
        requireAuth: true,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'age': age,
          'gender': gender,
        },
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile Updated Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update profile: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateBio({
    required String jobTitle,
    required String bio,
    required String shortBio,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.put(
        ApiEndpoints.updateBio,
        requireAuth: true,
        data: {
          'job_title': jobTitle,
          'bio': bio,
          'short_bio': shortBio,
        },
      );
      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile Bio Updated Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.put(
        ApiEndpoints.updatePassword,
        requireAuth: true,
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile Password Updated Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateAddress({
    required int countryId,
    required String stateStr,
    required String city,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.put(
        ApiEndpoints.updateAddress,
        requireAuth: true,
        data: {
          'country_id': countryId,
          'state': stateStr,
          'city': city,
          'address': address,
        },
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile Address Updated Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateSocialLinks({
    required String facebook,
    required String twitter,
    required String linkedin,
    required String website,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.put(
        ApiEndpoints.updateSocialLinks,
        requireAuth: true,
        data: {
          'facebook': facebook,
          'twitter': twitter,
          'linkedin': linkedin,
          'website': website,
        },
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile Social Links Updated Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }


  Future<bool> contactUs({
    required String name,
    required String email,
    required String subject,
    required String content,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.post(
        ApiEndpoints.contactUs,
        requireAuth: true,
        data: {
          'name': name,
          'email': email,
          'subject': subject,
          'message': content,
        },
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Contact us send Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> subscribeUs({
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);

      final res = await api.post(
        ApiEndpoints.subscribeUs,
        requireAuth: true,
        data: {'email': email},
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Contact us send Successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );

        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update : $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateProfileImage(File imageFile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);
      
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final res = await api.post(
        ApiEndpoints.updateProfile,
        requireAuth: true,
        data: formData,
        contentType: 'multipart/form-data',
      );

      if (!ref.mounted) return false;

      final status = res.data['status'];
      final message = res.data['message'] ?? 'Profile image updated successfully!';

      if (status == 'success') {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        await getProfile();
        return true;
      } else {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to upload profile picture: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }


}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/cash.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/profile_repo.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final String? imagePath;
  ProfileLoaded(this.user, {this.imagePath});
}
class ProfileError extends ProfileState {}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUser() async {
    emit(ProfileLoading());
    final user = await ProfileRepo.getUserData();
    if (user != null) {
      final path = cash.pref.getString('profile_image_${user.uid}'); // ✅
      final validPath = path != null && File(path).existsSync() ? path : null;
      emit(ProfileLoaded(user, imagePath: validPath));
    } else {
      emit(ProfileError());
    }
  }
  void reset() {
    emit(ProfileInitial());
  }
  Future<void> updateName(String newName) async {
    final current = state;
    if (current is ProfileLoaded) {
      await ProfileRepo.updateName(newName);
      emit(ProfileLoaded(
        UserModel(uid: current.user.uid, name: newName, email: current.user.email),
        imagePath: current.imagePath,
      ));
    }
  }

  Future<void> pickImage() async {
    final current = state;
    if (current is! ProfileLoaded) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    await cash.pref.setString('profile_image_${current.user.uid}', picked.path); // ✅
    emit(ProfileLoaded(current.user, imagePath: picked.path));
  }
}
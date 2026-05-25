import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/profile_repo.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}
class ProfileError extends ProfileState {}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUser() async {
    emit(ProfileLoading());
    final user = await ProfileRepo.getUserData();
    if (user != null) {
      emit(ProfileLoaded(user));
    } else {
      emit(ProfileError());
    }
  }

  Future<void> updateName(String newName) async {
    final current = state;
    if (current is ProfileLoaded) {
      await ProfileRepo.updateName(newName);
      emit(ProfileLoaded(UserModel(
        uid: current.user.uid,
        name: newName,
        email: current.user.email,
      )));
    }
  }
}
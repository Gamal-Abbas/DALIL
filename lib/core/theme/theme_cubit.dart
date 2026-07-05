import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../theme/app_theme.dart';

class ThemeCubit extends HydratedCubit<bool> {

  // true = dark, false = light
  ThemeCubit() : super(true);

  void toggleTheme() => emit(!state);

  @override
  bool? fromJson(Map<String, dynamic> json) => json['isDark'] as bool?;

  @override
  Map<String, dynamic>? toJson(bool state) => {'isDark': state};
}
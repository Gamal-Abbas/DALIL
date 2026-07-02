import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/cash.dart';
import '../../data/datasources/work_manager_service.dart';
import '../../data/repositories/notiication_repo.dart';

class NotificationsCubit extends Cubit<bool> {
  final WorkManagerService _workManager;

  NotificationsCubit(this._workManager) : super(true) {
    _loadState();
  }

  void _loadState() {
    final enabled = cash.pref.getBool('notifications_enabled') ?? true;
    emit(enabled);
    if (!enabled) _workManager.cancelWorkManager();
  }

  Future<void> toggle(bool value) async {
    await cash.pref.setBool('notifications_enabled', value);
    emit(value);

    if (value) {
      await _workManager.init();
    } else {
      await Future.wait([
        _workManager.cancelWorkManager(),
        NotificationRepo.flutterLocalNotificationsPlugin.cancel(id: 1), // ✅ بالـ id الثابت
      ]);
    }
  }
}
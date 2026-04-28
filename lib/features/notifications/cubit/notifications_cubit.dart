import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_notifications.dart';

class NotificationsState extends Equatable {
  final List<MockNotification> notifications;

  const NotificationsState({this.notifications = const []});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  void load() {
    final list = mockNotifications
        .map((n) => MockNotification(
              id: n.id,
              title: n.title,
              body: n.body,
              time: n.time,
              isRead: n.isRead,
              type: n.type,
            ))
        .toList();
    emit(NotificationsState(notifications: list));
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) {
        return MockNotification(
          id: n.id,
          title: n.title,
          body: n.body,
          time: n.time,
          isRead: true,
          type: n.type,
        );
      }
      return n;
    }).toList();
    emit(NotificationsState(notifications: updated));
  }

  void markAllRead() {
    final updated = state.notifications
        .map((n) => MockNotification(
              id: n.id,
              title: n.title,
              body: n.body,
              time: n.time,
              isRead: true,
              type: n.type,
            ))
        .toList();
    emit(NotificationsState(notifications: updated));
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications();
  Future<Either<Failure, Unit>> markAsRead(int id);
  Future<Either<Failure, Unit>> markAllAsRead();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> updateFcmToken(String token);
}

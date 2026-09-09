import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class UpdateFcmTokenUseCase {
  final NotificationRepository repository;

  UpdateFcmTokenUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String token) async {
    return await repository.updateFcmToken(token);
  }
}

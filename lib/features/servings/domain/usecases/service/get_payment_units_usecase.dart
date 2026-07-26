import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entity/payment_unit_entity.dart';
import '../../repository/services_repository.dart';

class GetPaymentUnitsUseCase {
  final ServicesRepository repository;

  GetPaymentUnitsUseCase(this.repository);

  Future<Either<Failure, List<PaymentUnitEntity>>> call() async {
    return await repository.getPaymentUnits();
  }
}

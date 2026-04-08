import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class FilterServicesUseCase implements UseCase<List<ServiceEntity>, FilterParams> {
  @override
  Future<Either<Failure, List<ServiceEntity>>> call(FilterParams params) async {
    throw UnimplementedError();
  }
}

class FilterParams {
  final String category;

  FilterParams({required this.category});
}
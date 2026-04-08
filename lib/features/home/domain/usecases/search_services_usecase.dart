import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class SearchServicesUseCase implements UseCase<List<ServiceEntity>, SearchParams> {
  @override
  Future<Either<Failure, List<ServiceEntity>>> call(SearchParams params) async {
    throw UnimplementedError();
  }
}

class SearchParams {
  final String query;

  SearchParams({required this.query});
}

// Assuming ServiceEntity exists, but for now placeholder
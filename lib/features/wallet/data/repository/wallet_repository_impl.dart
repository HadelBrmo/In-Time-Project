import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/wallet_entity.dart';
import '../../domain/repository/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WalletEntity>>> getMyWallets() async {
    try {
      final remoteWallets = await remoteDataSource.getMyWallets();
      return Right(remoteWallets);
    } on ServerExceptionWithDetails catch (e) {
      return Left(ServerFailureWithDetails(statusCode: e.statusCode, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
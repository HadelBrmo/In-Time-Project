import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/wallet_entity.dart';
import '../repository/wallet_repository.dart';

class GetMyWalletsUseCase {
  final WalletRepository repository;

  GetMyWalletsUseCase(this.repository);

  Future<Either<Failure, List<WalletEntity>>> call() async {
    return await repository.getMyWallets();
  }
}
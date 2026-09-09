import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/wallet_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<WalletEntity>>> getMyWallets();
}
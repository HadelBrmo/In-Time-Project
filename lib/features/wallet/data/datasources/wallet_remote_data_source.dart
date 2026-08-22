import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<List<WalletModel>> getMyWallets();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<WalletModel>> getMyWallets() async {
    try {
      final response = await dio.get('/wallets');

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;

        final List<dynamic> data = responseData['data'];
        return data.map((json) => WalletModel.fromJson(json)).toList();
      }

      throw ServerExceptionWithDetails.fromResponse(
        response,
        fallback: 'فشل تحميل المحفظة',
      );
    } on DioException catch (e) {
      throw ServerExceptionWithDetails.fromDioException(
        e,
        fallback: 'تعذر تحميل المحفظة',
      );
    } catch (e) {
      throw ServerExceptionWithDetails(
        message: 'حدث خطأ غير متوقع أثناء تحميل المحفظة',
      );
    }
  }
}
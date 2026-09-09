import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_wallets_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetMyWalletsUseCase getMyWalletsUseCase;

  WalletBloc({required this.getMyWalletsUseCase}) : super(WalletInitial()) {
    on<GetMyWalletsEvent>((event, emit) async {
      emit(WalletLoading());
      final failureOrWallets = await getMyWalletsUseCase();

      failureOrWallets.fold(
            (failure) => emit(WalletError(message: 'حدث خطا ')),
            (wallets) => emit(WalletLoaded(wallets: wallets)),
      );
    });
  }
}
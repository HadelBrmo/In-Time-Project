import 'package:flutter_bloc/flutter_bloc.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';
import '../../../domain/usecases/get_portfolio_usecase.dart';
import '../../../domain/usecases/upload_portfolio_image_usecase.dart';
import '../../../domain/usecases/upload_portfolio_file_usecase.dart';
import '../../../domain/usecases/upload_portfolio_link_usecase.dart';
import '../../../../../core/network/api_result.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolioUseCase getPortfolioUseCase;
  final UploadPortfolioImageUseCase uploadPortfolioImageUseCase;
  final UploadPortfolioFileUseCase uploadPortfolioFileUseCase;
  final UploadPortfolioLinkUseCase uploadPortfolioLinkUseCase;

  PortfolioBloc({
    required this.getPortfolioUseCase,
    required this.uploadPortfolioImageUseCase,
    required this.uploadPortfolioFileUseCase,
    required this.uploadPortfolioLinkUseCase,
  }) : super(PortfolioInitial()) {
    on<FetchPortfolio>((event, emit) async {
      emit(PortfolioLoading());
      
      final result = await getPortfolioUseCase(event.userId);
      
      switch (result) {
        case Success(data: final items):
          emit(PortfolioLoaded(items));
        case FailureResult(failure: final failure):
          emit(PortfolioError(failure.message));
      }
    });

    on<UploadPortfolioImage>((event, emit) async {
      emit(PortfolioUploading());
      
      final result = await uploadPortfolioImageUseCase(
        userId: event.userId,
        image: event.image,
        title: event.title,
      );
      
      switch (result) {
        case Success():
          emit(PortfolioUploadSuccess());
          add(FetchPortfolio(event.userId));
        case FailureResult(failure: final failure):
          emit(PortfolioUploadError(failure.message));
      }
    });

    on<UploadPortfolioFile>((event, emit) async {
      emit(PortfolioUploading());
      
      final result = await uploadPortfolioFileUseCase(
        userId: event.userId,
        file: event.file,
        title: event.title,
      );
      
      switch (result) {
        case Success():
          emit(PortfolioUploadSuccess());
          add(FetchPortfolio(event.userId));
        case FailureResult(failure: final failure):
          emit(PortfolioUploadError(failure.message));
      }
    });

    on<UploadPortfolioLink>((event, emit) async {
      emit(PortfolioUploading());
      
      final result = await uploadPortfolioLinkUseCase(
        userId: event.userId,
        url: event.url,
        title: event.title,
      );
      
      switch (result) {
        case Success():
          emit(PortfolioUploadSuccess());
          add(FetchPortfolio(event.userId));
        case FailureResult(failure: final failure):
          emit(PortfolioUploadError(failure.message));
      }
    });
  }
}

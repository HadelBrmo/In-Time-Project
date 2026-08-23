import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_complaints_against_me_usecase.dart';

abstract class ComplaintsAgainstMeState extends Equatable {
  const ComplaintsAgainstMeState();
  @override
  List<Object?> get props => [];
}

class ComplaintsAgainstMeInitial extends ComplaintsAgainstMeState {}
class ComplaintsAgainstMeLoading extends ComplaintsAgainstMeState {}
class ComplaintsAgainstMeLoaded extends ComplaintsAgainstMeState {
  final List<dynamic> complaints;
  const ComplaintsAgainstMeLoaded(this.complaints);
  @override
  List<Object?> get props => [complaints];
}
class ComplaintsAgainstMeError extends ComplaintsAgainstMeState {
  final String message;
  const ComplaintsAgainstMeError(this.message);
  @override
  List<Object?> get props => [message];
}

class ComplaintsAgainstMeCubit extends Cubit<ComplaintsAgainstMeState> {
  final GetComplaintsAgainstMeUseCase getComplaintsAgainstMeUseCase;

  ComplaintsAgainstMeCubit({required this.getComplaintsAgainstMeUseCase})
      : super(ComplaintsAgainstMeInitial());

  Future<void> fetchComplaintsAgainstMe() async {
    emit(ComplaintsAgainstMeLoading());
    try {
      final complaints = await getComplaintsAgainstMeUseCase();
      emit(ComplaintsAgainstMeLoaded(complaints));
    } catch (e) {
      emit(ComplaintsAgainstMeError(e.toString()));
    }
  }
}

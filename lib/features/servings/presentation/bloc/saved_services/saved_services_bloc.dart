import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/service_entity.dart';
import '../../../domain/repository/saved_services_repository.dart';

// Events
abstract class SavedServicesEvent extends Equatable {
  const SavedServicesEvent();
  @override
  List<Object?> get props => [];
}

class GetSavedServicesEvent extends SavedServicesEvent {}

class ToggleSaveServiceEvent extends SavedServicesEvent {
  final ServiceEntity service;
  const ToggleSaveServiceEvent(this.service);
  @override
  List<Object?> get props => [service];
}

class CheckIsSavedEvent extends SavedServicesEvent {
  final int serviceId;
  const CheckIsSavedEvent(this.serviceId);
}

class ClearAllSavedServicesEvent extends SavedServicesEvent {}

// State
abstract class SavedServicesState extends Equatable {
  const SavedServicesState();
  @override
  List<Object?> get props => [];
}

class SavedServicesInitial extends SavedServicesState {}

class SavedServicesLoading extends SavedServicesState {}

class SavedServicesLoaded extends SavedServicesState {
  final List<ServiceEntity> savedServices;
  const SavedServicesLoaded(this.savedServices);
  @override
  List<Object?> get props => [savedServices];
}

class IsServiceSavedState extends SavedServicesState {
  final bool isSaved;
  const IsServiceSavedState(this.isSaved);
  @override
  List<Object?> get props => [isSaved];
}

class SavedServicesError extends SavedServicesState {
  final String message;
  const SavedServicesError(this.message);
}

// Bloc
class SavedServicesBloc extends Bloc<SavedServicesEvent, SavedServicesState> {
  final SavedServicesRepository repository;

  SavedServicesBloc({required this.repository}) : super(SavedServicesInitial()) {
    on<GetSavedServicesEvent>(_onGetSavedServices);
    on<ToggleSaveServiceEvent>(_onToggleSaveService);
    on<CheckIsSavedEvent>(_onCheckIsSaved);
    on<ClearAllSavedServicesEvent>(_onClearAll);
  }

  Future<void> _onGetSavedServices(GetSavedServicesEvent event, Emitter<SavedServicesState> emit) async {
    emit(SavedServicesLoading());
    try {
      final services = await repository.getSavedServices();
      emit(SavedServicesLoaded(services));
    } catch (e) {
      emit(const SavedServicesError("فشل في جلب الخدمات المحفوظة"));
    }
  }

  Future<void> _onToggleSaveService(ToggleSaveServiceEvent event, Emitter<SavedServicesState> emit) async {
    try {
      await repository.toggleSaveService(event.service);
      final services = await repository.getSavedServices();
      emit(SavedServicesLoaded(services));
    } catch (e) {
      if (kDebugMode) print("[SavedServices] Toggle Error: $e");
      emit(const SavedServicesError("حدث خطأ أثناء تحديث المحفوظات"));
    }
  }

  Future<void> _onCheckIsSaved(CheckIsSavedEvent event, Emitter<SavedServicesState> emit) async {
    final isSaved = await repository.isServiceSaved(event.serviceId);
    emit(IsServiceSavedState(isSaved));
  }

  Future<void> _onClearAll(ClearAllSavedServicesEvent event, Emitter<SavedServicesState> emit) async {
    try {
      await repository.clearAllSavedServices();
      emit(const SavedServicesLoaded([]));
    } catch (e) {
      emit(const SavedServicesError("فشل في مسح المحفوظات"));
    }
  }
}

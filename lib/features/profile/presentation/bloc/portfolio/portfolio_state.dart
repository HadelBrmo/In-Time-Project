import 'package:equatable/equatable.dart';
import '../../../domain/entities/portfolio_item_entity.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();
  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<PortfolioItemEntity> items;
  const PortfolioLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class PortfolioError extends PortfolioState {
  final String message;
  const PortfolioError(this.message);
  @override
  List<Object?> get props => [message];
}

class PortfolioUploading extends PortfolioState {}

class PortfolioUploadSuccess extends PortfolioState {}

class PortfolioUploadError extends PortfolioState {
  final String message;
  const PortfolioUploadError(this.message);
  @override
  List<Object?> get props => [message];
}

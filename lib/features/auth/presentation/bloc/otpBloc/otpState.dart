import 'package:equatable/equatable.dart';

enum OtpStatus { initial, loading, success, error }

class OtpState extends Equatable {
  final OtpStatus status;
  final String errorMessage;
  final bool isOtpSent;

  const OtpState({
    this.status = OtpStatus.initial,
    this.errorMessage = "",
    this.isOtpSent = false,
  });

  OtpState copyWith({
    OtpStatus? status,
    String? errorMessage,
    bool? isOtpSent,
  }) {
    return OtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isOtpSent: isOtpSent ?? this.isOtpSent,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isOtpSent];
}
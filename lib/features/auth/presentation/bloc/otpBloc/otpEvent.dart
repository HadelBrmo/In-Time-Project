import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpRequestedEvent extends OtpEvent {
  final String email;

  const SendOtpRequestedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
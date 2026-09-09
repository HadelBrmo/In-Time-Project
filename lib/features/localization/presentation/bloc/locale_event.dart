import 'package:flutter/material.dart';

abstract class LocaleEvent {
  const LocaleEvent();
}

class ChangeLocaleEvent extends LocaleEvent {
  final String languageCode;
  const ChangeLocaleEvent(this.languageCode);
}

class GetSavedLocaleEvent extends LocaleEvent {
  const GetSavedLocaleEvent();
}
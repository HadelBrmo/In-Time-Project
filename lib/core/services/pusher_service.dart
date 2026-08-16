import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:in_time/core/constants/app_strings.dart';
import 'package:in_time/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:in_time/injection_container.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class PusherService {
  PusherChannelsClient? _client;
  final _eventController = StreamController<PusherEvent>.broadcast();
  final Map<String, StreamSubscription> _subscriptions = {};

  Stream<PusherEvent> get eventStream => _eventController.stream;

  Future<void> init() async {
    final authLocal = sl<AuthLocalDataSource>();
    final token = await authLocal.getToken();

    if (token == null) {
      if (kDebugMode) print("[Pusher] No token found, WebSocket will not start.");
      return;
    }

    try {
      if (kDebugMode) print("[Pusher] Initializing via dart_pusher_channels...");

      final options = PusherChannelsOptions.fromHost(
        scheme: 'wss',
        host: ApiStringConstants.wsHost,
        key: ApiStringConstants.wsKey,
        port: ApiStringConstants.wsPort,
      );

      _client = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (error, trace, refresh) {
          if (kDebugMode) print("[Pusher] Connection Error: $error");
          refresh();
        },
      );

      _client!.eventStream.listen((event) {
        if (event is PusherChannelsReadEvent) {
          _eventController.add(PusherEvent(
            eventName: event.name,
            channelName: event.channelName ?? "",
            data: event.data,
          ));
        }
      });

      _client!.lifecycleStream.listen((state) {
        if (kDebugMode) print("[Pusher] State: ${state.runtimeType}");
      });

      _client!.connect();
    } catch (e) {
      if (kDebugMode) print("[Pusher] Init error: $e");
    }
  }

  Future<void> subscribe(String channelName) async {
    if (_client == null) return;
    try {
      if (_subscriptions.containsKey(channelName)) return;

      final authLocal = sl<AuthLocalDataSource>();
      final token = await authLocal.getToken();

      if (kDebugMode) print("[Pusher] Subscribing to: $channelName");

      final isPrivate = channelName.startsWith('private-') || channelName.startsWith('presence-');

      if (isPrivate && token != null) {
        if (channelName.startsWith('presence-')) {
          final channel = _client!.presenceChannel(
            channelName,
            authorizationDelegate: _MyPusherPresenceAuthDelegate(token),
          );
          channel.subscribe();
        } else {
          final channel = _client!.privateChannel(
            channelName,
            authorizationDelegate: _MyPusherAuthDelegate(token),
          );
          channel.subscribe();
        }
      } else {
        final channel = _client!.publicChannel(channelName);
        channel.subscribe();
      }

      _subscriptions[channelName] = StreamSubscriptionStub();

    } catch (e) {
      if (kDebugMode) print("[Pusher] Subscribe error ($channelName): $e");
    }
  }

  Future<void> unsubscribe(String channelName) async {
    if (_client == null) return;
    try {
      if (kDebugMode) print("[Pusher] Unsubscribing from: $channelName");
      _client!.publicChannel(channelName).unsubscribe();
      _subscriptions.remove(channelName);
    } catch (e) {
      if (kDebugMode) print("[Pusher] Unsubscribe error ($channelName): $e");
    }
  }

  void disconnect() {
    if (kDebugMode) print("[Pusher] Disconnecting...");
    _client?.disconnect();
    _subscriptions.clear();
  }
}

class PusherEvent {
  final String eventName;
  final String channelName;
  final dynamic data;

  PusherEvent({required this.eventName, required this.channelName, this.data});
}

class _MyPusherAuthDelegate implements EndpointAuthorizableChannelAuthorizationDelegate<PrivateChannelAuthorizationData> {
  final String token;
  _MyPusherAuthDelegate(this.token);

  @override
  EndpointAuthFailedCallback? get onAuthFailed => (error, trace) {
    if (kDebugMode) print("[Pusher] Auth Failed: $error");
  };

  @override
  FutureOr<PrivateChannelAuthorizationData> authorizationData(String socketId, String channelName) async {
    final response = await sl<Dio>().post(
      ApiStringConstants.wsAuthEndpoint,
      data: {
        "socket_id": socketId,
        "channel_name": channelName,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final dynamic responseData = response.data;
    Map<String, dynamic> data;
    if (responseData is Map && responseData.containsKey('data')) {
      data = Map<String, dynamic>.from(responseData['data']);
    } else {
      data = Map<String, dynamic>.from(responseData);
    }

    return PrivateChannelAuthorizationData(
      authKey: data['auth'],
    );
  }
}

class _MyPusherPresenceAuthDelegate implements EndpointAuthorizableChannelAuthorizationDelegate<PresenceChannelAuthorizationData> {
  final String token;
  _MyPusherPresenceAuthDelegate(this.token);

  @override
  EndpointAuthFailedCallback? get onAuthFailed => (error, trace) {
    if (kDebugMode) print("[Pusher] Presence Auth Failed: $error");
  };

  @override
  FutureOr<PresenceChannelAuthorizationData> authorizationData(String socketId, String channelName) async {
    final response = await sl<Dio>().post(
      ApiStringConstants.wsAuthEndpoint,
      data: {
        "socket_id": socketId,
        "channel_name": channelName,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final dynamic responseData = response.data;
    Map<String, dynamic> data;
    if (responseData is Map && responseData.containsKey('data')) {
      data = Map<String, dynamic>.from(responseData['data']);
    } else {
      data = Map<String, dynamic>.from(responseData);
    }

    return PresenceChannelAuthorizationData(
      authKey: data['auth'],
      channelDataEncoded: data['channel_data'],
    );
  }
}

class StreamSubscriptionStub implements StreamSubscription {
  @override
  Future cancel() async {}
  @override
  void onData(void Function(dynamic data)? handleData) {}
  @override
  void onError(Function? handleError) {}
  @override
  void onDone(void Function()? handleDone) {}
  @override
  void pause([Future? resumeSignal]) {}
  @override
  void resume() {}
  @override
  bool get isPaused => false;
  @override
  Future<E> asFuture<E>([E? futureValue]) => Future.value(futureValue);
}

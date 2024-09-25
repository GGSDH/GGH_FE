import 'dart:async';

import '../data/models/response/photobook_response.dart';

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _eventController = StreamController<Event>.broadcast();

  Stream<T> on<T>() => _eventController.stream.where((event) => event is T).cast<T>();

  void fire(event) => _eventController.add(event);

  void dispose() => _eventController.close();
}

sealed class Event { }
final class ChangeNicknameEvent extends Event {
  final String nickname;

  ChangeNicknameEvent(this.nickname);
}
final class ChangeLaneLikeEvent extends Event {
  final int laneId;
  final bool isLike;

  ChangeLaneLikeEvent(this.laneId, this.isLike);
}
final class ChangeStationLikeEvent extends Event {
  final int stationId;
  final bool isLike;

  ChangeStationLikeEvent(this.stationId, this.isLike);
}

final class PhotobookAddEvent extends Event {
  final PhotobookResponse photobook;

  PhotobookAddEvent(this.photobook);
}
final class PhotobookRemoveEvent extends Event {
  final int photobookId;

  PhotobookRemoveEvent(this.photobookId);
}

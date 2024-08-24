import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/response/add_photobook_response.dart';

final class AddPhotoTicketState {
  final bool isLoading;
  final bool isChoosing;
  final String title;
  final List<PhotoItem> photos;
  final int selectedPhotoIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  final String period;
  final String location;

  AddPhotoTicketState({
    required this.isLoading,
    required this.isChoosing,
    required this.title,
    required this.photos,
    required this.selectedPhotoIndex,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.location,
  });

  factory AddPhotoTicketState.initial() {
    return AddPhotoTicketState(
      isLoading: false,
      isChoosing: false,
      photos: [],
      selectedPhotoIndex: 0,
      title: "",
      startDate: null,
      endDate: null,
      period: "",
      location: "",
    );
  }

  AddPhotoTicketState copyWith({
    bool? isLoading,
    bool? isChoosing,
    String? title,
    List<PhotoItem>? photos,
    int? selectedPhotoIndex,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
    String? location,
  }) {
    return AddPhotoTicketState(
      isLoading: isLoading ?? this.isLoading,
      isChoosing: isChoosing ?? this.isChoosing,
      title: title ?? this.title,
      photos: photos ?? this.photos,
      selectedPhotoIndex: selectedPhotoIndex ?? this.selectedPhotoIndex,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
      location: location ?? this.location,
    );
  }
}

sealed class AddPhotoTicketEvent {}
final class AddPhotoTicketInitialize extends AddPhotoTicketEvent {}
final class AddPhotoTicketIndexChanged extends AddPhotoTicketEvent {}
final class AddPhotoTicketPressStart extends AddPhotoTicketEvent {}
final class AddPhotoTicketPressEnd extends AddPhotoTicketEvent {}
final class AddPhotoTicket extends AddPhotoTicketEvent {
  final String photoId;

  AddPhotoTicket({
    required this.photoId,
  });
}

sealed class AddPhotoTicketSideEffect {}
final class AddPhotoTicketComplete extends AddPhotoTicketSideEffect {
  final int photoTicketId;

  AddPhotoTicketComplete(this.photoTicketId);
}
final class AddPhotoTicketShowError extends AddPhotoTicketSideEffect {
  final String message;

  AddPhotoTicketShowError(this.message);
}

class AddPhotoTicketBloc extends SideEffectBloc<AddPhotoTicketEvent, AddPhotoTicketState, AddPhotoTicketSideEffect> {
  final PhotobookRepository _photobookRepository;

  AddPhotoTicketBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
        super(AddPhotoTicketState.initial()) {
    on<AddPhotoTicketInitialize>(_onInitialize);
    on<AddPhotoTicketIndexChanged>(_onAddPhotoTicketIndexChanged);
    on<AddPhotoTicketPressStart>(_onPressStart);
    on<AddPhotoTicketPressEnd>(_onPressEnd);
    on<AddPhotoTicket>(_onAddPhotoTicket);
  }

  void _onInitialize(
    AddPhotoTicketInitialize event,
    Emitter<AddPhotoTicketState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.getRandomPhotobook();

      response.when(
        success: (photobook) {
          emit(state.copyWith(
            isLoading: false,
            title: photobook.title,
            photos: photobook.photos,
            selectedPhotoIndex: 0,
            startDate: DateTime.parse(photobook.startDateTime),
            endDate: DateTime.parse(photobook.endDateTime),
            period: "${photobook.startDateTime} ~ ${photobook.endDateTime}",
            location: getMostFrequentLocationName(photobook.photos),
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(AddPhotoTicketShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(AddPhotoTicketShowError(e.toString()));
    }
  }

  void _onAddPhotoTicketIndexChanged(
    AddPhotoTicketIndexChanged event,
    Emitter<AddPhotoTicketState> emit,
  ) {
    final updatedIndex = (state.selectedPhotoIndex + 1) % state.photos.length;
    emit(state.copyWith(selectedPhotoIndex: updatedIndex));
  }

  void _onPressStart(
    AddPhotoTicketPressStart event,
    Emitter<AddPhotoTicketState> emit,
  ) {
    emit(state.copyWith(isChoosing: true));
  }

  void _onPressEnd(
    AddPhotoTicketPressEnd event,
    Emitter<AddPhotoTicketState> emit,
  ) {
    emit(state.copyWith(isChoosing: false));
  }

  void _onAddPhotoTicket(
    AddPhotoTicket event,
    Emitter<AddPhotoTicketState> emit,
  ) async {

  }

  String? getMostFrequentLocationName(List<PhotoItem> photos) {
    final nameCounts = <String, int>{};

    for (var name in photos.map((photo) => photo.location?.name).where((name) => name != null)) {
      nameCounts[name!] = (nameCounts[name] ?? 0) + 1;
    }

    return nameCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
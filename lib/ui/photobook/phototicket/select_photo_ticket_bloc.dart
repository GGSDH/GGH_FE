import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/response/photobook_response.dart';

final class SelectPhotoTicketState {
  final bool isLoading;
  final bool isChoosing;
  final String title;
  final List<PhotoItem> photos;
  final int selectedPhotoIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  final String period;
  final String location;

  SelectPhotoTicketState({
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

  factory SelectPhotoTicketState.initial() {
    return SelectPhotoTicketState(
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

  SelectPhotoTicketState copyWith({
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
    return SelectPhotoTicketState(
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

sealed class SelectPhotoTicketEvent {}
final class SelectPhotoTicketInitialize extends SelectPhotoTicketEvent {}
final class SelectPhotoTicketIndexChanged extends SelectPhotoTicketEvent {}
final class SelectPhotoTicketPressStart extends SelectPhotoTicketEvent {}
final class SelectPhotoTicketPressEnd extends SelectPhotoTicketEvent {}
final class SelectPhotoTicket extends SelectPhotoTicketEvent {
  final String photoId;

  SelectPhotoTicket({
    required this.photoId,
  });
}

sealed class SelectPhotoTicketSideEffect {}
final class SelectPhotoTicketShowError extends SelectPhotoTicketSideEffect {
  final String message;

  SelectPhotoTicketShowError(this.message);
}

class SelectPhotoTicketBloc extends SideEffectBloc<SelectPhotoTicketEvent, SelectPhotoTicketState, SelectPhotoTicketSideEffect> {
  final PhotobookRepository _photobookRepository;

  SelectPhotoTicketBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
        super(SelectPhotoTicketState.initial()) {
    on<SelectPhotoTicketInitialize>(_onInitialize);
    on<SelectPhotoTicketIndexChanged>(_onSelectPhotoTicketIndexChanged);
    on<SelectPhotoTicketPressStart>(_onPressStart);
    on<SelectPhotoTicketPressEnd>(_onPressEnd);
  }

  void _onInitialize(
    SelectPhotoTicketInitialize event,
    Emitter<SelectPhotoTicketState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.getRandomPhotobook();

      response.when(
        success: (data) {
          emit(state.copyWith(
            isLoading: false,
            title: data.title,
            photos: data.photos,
            selectedPhotoIndex: 0,
            startDate: DateTime.parse(data.startDate),
            endDate: DateTime.parse(data.endDate),
            period: "${data.startDate} ~ ${data.endDate}",
            location: data.location?.name ?? '',
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(SelectPhotoTicketShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(SelectPhotoTicketShowError(e.toString()));
    }
  }

  void _onSelectPhotoTicketIndexChanged(
    SelectPhotoTicketIndexChanged event,
    Emitter<SelectPhotoTicketState> emit,
  ) {
    final updatedIndex = (state.selectedPhotoIndex + 1) % state.photos.length;
    emit(state.copyWith(selectedPhotoIndex: updatedIndex));
  }

  void _onPressStart(
    SelectPhotoTicketPressStart event,
    Emitter<SelectPhotoTicketState> emit,
  ) {
    emit(state.copyWith(isChoosing: true));
  }

  void _onPressEnd(
    SelectPhotoTicketPressEnd event,
    Emitter<SelectPhotoTicketState> emit,
  ) {
    emit(state.copyWith(isChoosing: false));
  }

  String? getMostFrequentLocationName(List<PhotoItem> photos) {
    final nameCounts = <String, int>{};

    for (var name in photos.map((photo) => photo.location?.name).where((name) => name != null)) {
      nameCounts[name!] = (nameCounts[name] ?? 0) + 1;
    }

    return nameCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
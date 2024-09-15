import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/keyword_search_result_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_keyword_response.dart';
import 'package:gyeonggi_express/data/repository/search_repository.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPopularKeywords extends SearchEvent {}

class PerformSearch extends SearchEvent {
  final String keyword;
  PerformSearch(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class ClearSearch extends SearchEvent {}

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class PopularKeywordsLoaded extends SearchState {
  final List<PopularKeyword> keywords;
  PopularKeywordsLoaded(this.keywords);

  @override
  List<Object> get props => [keywords];
}

class SearchResultsLoaded extends SearchState {
  final List<KeywordSearchResult> results;
  SearchResultsLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class NoSearchResults extends SearchState {
  final String searchTerm;
  NoSearchResults(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<FetchPopularKeywords>(_onFetchPopularKeywords);
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onFetchPopularKeywords(
    FetchPopularKeywords event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await repository.getPopularKeywords();
    result.when(
      success: (keywords) => emit(PopularKeywordsLoaded(keywords)),
      apiError: (errorMessage, errorCode) =>
          emit(SearchError('$errorMessage (Code: $errorCode)')),
    );
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await repository.search(event.keyword);
    result.when(
      success: (searchResults) {
        if (searchResults.isEmpty) {
          emit(NoSearchResults(event.keyword));
        } else {
          emit(SearchResultsLoaded(searchResults));
        }
      },
      apiError: (errorMessage, errorCode) {
        if (errorCode == '404') {
          emit(NoSearchResults(event.keyword));
        } else {
          emit(SearchError('$errorMessage (Code: $errorCode)'));
        }
      },
    );
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}

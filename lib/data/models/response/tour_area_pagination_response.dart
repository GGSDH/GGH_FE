import 'package:gyeonggi_express/data/models/response/tour_area_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tour_area_pagination_response.g.dart';

@JsonSerializable()
class TourAreaPaginationResponse {
  @JsonKey(name: 'content')
  final List<TourAreaResponse> content;

  @JsonKey(name: 'pageable')
  final Pageable pageable;

  @JsonKey(name: 'totalPages')
  final int totalPages;

  @JsonKey(name: 'totalElements')
  final int totalElements;

  @JsonKey(name: 'last')
  final bool last;

  @JsonKey(name: 'numberOfElements')
  final int numberOfElements;

  @JsonKey(name: 'size')
  final int size;

  @JsonKey(name: 'number')
  final int number;

  @JsonKey(name: 'sort')
  final Sort sort;

  @JsonKey(name: 'first')
  final bool first;

  @JsonKey(name: 'empty')
  final bool empty;

  TourAreaPaginationResponse({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.numberOfElements,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.empty,
  });

  factory TourAreaPaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$TourAreaPaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaPaginationResponseToJson(this);
}

@JsonSerializable()
class Pageable {
  @JsonKey(name: 'pageNumber')
  final int pageNumber;

  @JsonKey(name: 'pageSize')
  final int pageSize;

  @JsonKey(name: 'sort')
  final Sort sort;

  @JsonKey(name: 'offset')
  final int offset;

  @JsonKey(name: 'paged')
  final bool paged;

  @JsonKey(name: 'unpaged')
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.sort,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);
}

@JsonSerializable()
class Sort {
  @JsonKey(name: 'unsorted')
  final bool unsorted;

  @JsonKey(name: 'sorted')
  final bool sorted;

  @JsonKey(name: 'empty')
  final bool empty;

  Sort({
    required this.unsorted,
    required this.sorted,
    required this.empty,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}

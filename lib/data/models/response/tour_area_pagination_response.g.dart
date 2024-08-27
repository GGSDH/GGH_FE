// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaPaginationResponse _$TourAreaPaginationResponseFromJson(
        Map<String, dynamic> json) =>
    TourAreaPaginationResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => TourArea.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      last: json['last'] as bool,
      numberOfElements: (json['numberOfElements'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      first: json['first'] as bool,
      empty: json['empty'] as bool,
    );

Map<String, dynamic> _$TourAreaPaginationResponseToJson(
        TourAreaPaginationResponse instance) =>
    <String, dynamic>{
      'content': instance.content.map((e) => e.toJson()).toList(),
      'pageable': instance.pageable.toJson(),
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'last': instance.last,
      'numberOfElements': instance.numberOfElements,
      'size': instance.size,
      'number': instance.number,
      'sort': instance.sort.toJson(),
      'first': instance.first,
      'empty': instance.empty,
    };

Pageable _$PageableFromJson(Map<String, dynamic> json) => Pageable(
      pageNumber: (json['pageNumber'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      offset: (json['offset'] as num).toInt(),
      paged: json['paged'] as bool,
      unpaged: json['unpaged'] as bool,
    );

Map<String, dynamic> _$PageableToJson(Pageable instance) => <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'sort': instance.sort.toJson(),
      'offset': instance.offset,
      'paged': instance.paged,
      'unpaged': instance.unpaged,
    };

Sort _$SortFromJson(Map<String, dynamic> json) => Sort(
      unsorted: json['unsorted'] as bool,
      sorted: json['sorted'] as bool,
      empty: json['empty'] as bool,
    );

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
      'unsorted': instance.unsorted,
      'sorted': instance.sorted,
      'empty': instance.empty,
    };

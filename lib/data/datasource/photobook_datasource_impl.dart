import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/photobook_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';
import 'package:gyeonggi_express/data/models/response/photobook_detail_response.dart';
import 'package:gyeonggi_express/data/models/response/random_photobook_response.dart';

import '../models/response/photobook_list_response.dart';

class PhotobookDataSourceImpl implements PhotobookDataSource {
  final Dio _dio;

  PhotobookDataSourceImpl(this._dio);

  @override
  Future<ApiResult<List<Photobook>>> getPhotobooks() {
    return _dio.makeRequest<List<Photobook>>(
      () => _dio.get('v1/photobook'),
      (data) =>
      (data as List).map((e) =>
          Photobook.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<AddPhotobookResponse>> addPhotobook({
    required String title,
    required String startDate,
    required String endDate,
    required List<AddPhotoItem> photos
  }) async {
    final addPhotobookRequest = AddPhotobookRequest(
      title: title,
      startDate: startDate,
      endDate: endDate,
      photos: photos
    );

    return _dio.makeRequest<AddPhotobookResponse>(
      () => _dio.post(
        'v1/photobook',
        data: addPhotobookRequest.toJson(),
      ),
      (data) => AddPhotobookResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<PhotobookDetailResponse>> getPhotobookDetail(int photobookId) {
    return _dio.makeRequest<PhotobookDetailResponse>(
      () => _dio.get('v1/photobook/$photobookId'),
      (data) => PhotobookDetailResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<bool>> deletePhotobook(int photobookId) {
    return _dio.makeRequest<bool>(
      () => _dio.delete('v1/photobook/$photobookId'),
      (data) => true
    );
  }

  @override
  Future<ApiResult<RandomPhotobookResponse>> getRandomPhotobook() {
    return _dio.makeRequest<RandomPhotobookResponse>(
      () => _dio.get('v1/photo-ticket/random'),
      (data) => RandomPhotobookResponse.fromJson(data as Map<String, dynamic>)
    );
  }

}
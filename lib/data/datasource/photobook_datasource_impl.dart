import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/photobook_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';
import 'package:gyeonggi_express/data/models/response/photobook_response.dart';

import '../models/response/photo_ticket_response.dart';

class PhotobookDataSourceImpl implements PhotobookDataSource {
  final Dio _dio;

  PhotobookDataSourceImpl(this._dio);

  @override
  Future<ApiResult<List<PhotobookResponse>>> getPhotobooks() {
    return _dio.makeRequest<List<PhotobookResponse>>(
      () => _dio.get('v1/photobook'),
      (data) =>
      (data as List).map((e) =>
          PhotobookResponse.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<PhotobookResponse>> addPhotobook({
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

    return _dio.makeRequest<PhotobookResponse>(
      () => _dio.post(
        'v1/photobook',
        data: addPhotobookRequest.toJson(),
      ),
      (data) => PhotobookResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<PhotobookResponse>> getPhotobookDetail(int photobookId) {
    return _dio.makeRequest<PhotobookResponse>(
      () => _dio.get('v1/photobook/$photobookId'),
      (data) => PhotobookResponse.fromJson(data as Map<String, dynamic>)
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
  Future<ApiResult<PhotobookResponse>> getRandomPhotobook() {
    return _dio.makeRequest<PhotobookResponse>(
      () => _dio.get('v1/photo-ticket/random'),
      (data) => PhotobookResponse.fromJson(data as Map<String, dynamic>)
    );
  }

  @override
  Future<ApiResult<List<PhotoTicketResponse>>> getPhotoTickets() {
    return _dio.makeRequest<List<PhotoTicketResponse>>(
      () => _dio.get('v1/photo-ticket'),
      (data) =>
      (data as List).map((e) =>
          PhotoTicketResponse.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  @override
  Future<ApiResult<PhotoTicketResponse>> addPhotoTicket(String photoId) {
    // URL에 photoId를 포함하여 요청
    final String url = 'v1/photo-ticket/$photoId/save';

    return _dio.makeRequest<PhotoTicketResponse>(
          () => _dio.post(url),
          (data) => PhotoTicketResponse.fromJson(data as Map<String, dynamic>),
    );
  }

}
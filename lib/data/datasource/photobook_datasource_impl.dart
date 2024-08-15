import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/photobook_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';

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

}
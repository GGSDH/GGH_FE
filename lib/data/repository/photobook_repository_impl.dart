import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';

import '../datasource/photobook_datasource.dart';

class PhotobookRepositoryImpl implements PhotobookRepository {
  final PhotobookDataSource _photobookDataSource;

  PhotobookRepositoryImpl(this._photobookDataSource);

  @override
  Future<ApiResult<AddPhotobookResponse>> addPhotobook({
    required String title,
    required String startDate,
    required String endDate,
    required List<AddPhotoItem> photos}
  ) => _photobookDataSource.addPhotobook(
    title: title,
    startDate: startDate,
    endDate: endDate,
    photos: photos
  );
}
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';
import 'package:gyeonggi_express/data/models/response/random_photobook_response.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';

import '../datasource/photobook_datasource.dart';
import '../models/response/photo_ticket_response.dart';
import '../models/response/photobook_detail_response.dart';
import '../models/response/photobook_list_response.dart';

class PhotobookRepositoryImpl implements PhotobookRepository {
  final PhotobookDataSource _photobookDataSource;

  PhotobookRepositoryImpl(this._photobookDataSource);

  @override
  Future<ApiResult<List<Photobook>>> getPhotobooks() => _photobookDataSource.getPhotobooks();

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

  @override
  Future<ApiResult<PhotobookDetailResponse>> getPhotobookDetail(int photobookId) => _photobookDataSource.getPhotobookDetail(photobookId);

  @override
  Future<ApiResult<bool>> deletePhotobook(int photobookId) => _photobookDataSource.deletePhotobook(photobookId);

  @override
  Future<ApiResult<RandomPhotobookResponse>> getRandomPhotobook() => _photobookDataSource.getRandomPhotobook();

  @override
  Future<ApiResult<List<PhotoTicketResponse>>> getPhotoTickets() => _photobookDataSource.getPhotoTickets();
}
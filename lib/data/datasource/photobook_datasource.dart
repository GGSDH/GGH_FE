import 'package:gyeonggi_express/data/models/request/add_photobook_request.dart';

import '../models/api_result.dart';
import '../models/response/photo_ticket_response.dart';
import '../models/response/photobook_response.dart';

abstract class PhotobookDataSource {

  Future<ApiResult<List<PhotobookResponse>>> getPhotobooks();

  Future<ApiResult<PhotobookResponse>> addPhotobook({
    required String title,
    required String startDate,
    required String endDate,
    required List<AddPhotoItem> photos,
  });

  Future<ApiResult<PhotobookResponse>> getPhotobookDetail(int photobookId);

  Future<ApiResult<bool>> deletePhotobook(int photobookId);

  Future<ApiResult<PhotobookResponse>> getRandomPhotobook();

  Future<ApiResult<List<PhotoTicketResponse>>> getPhotoTickets();

}
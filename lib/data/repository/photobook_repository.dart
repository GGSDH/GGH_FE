import 'package:gyeonggi_express/data/models/response/photobook_detail_response.dart';

import '../models/api_result.dart';
import '../models/request/add_photobook_request.dart';
import '../models/response/add_photobook_response.dart';
import '../models/response/photobook_list_response.dart';

abstract class PhotobookRepository {
  Future<ApiResult<List<Photobook>>> getPhotobooks();

  Future<ApiResult<AddPhotobookResponse>> addPhotobook({
    required String title,
    required String startDate,
    required String endDate,
    required List<AddPhotoItem> photos,
  });

  Future<ApiResult<PhotobookDetailResponse>> getPhotobookDetail(int photobookId);

  Future<ApiResult<bool>> deletePhotobook(int photobookId);
}
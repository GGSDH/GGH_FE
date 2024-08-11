import '../models/api_result.dart';
import '../models/request/add_photobook_request.dart';
import '../models/response/add_photobook_response.dart';

abstract class PhotobookRepository {
  Future<ApiResult<AddPhotobookResponse>> addPhotobook({
    required String title,
    required String startDate,
    required String endDate,
    required List<AddPhotoItem> photos,
  });
}
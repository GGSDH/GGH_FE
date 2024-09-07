import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';

abstract class TourAreaRepository {
  Future<ApiResult<TourAreaDetail>> getTourAreaDetail(int tourAreaId);

  Future<ApiResult<bool>> likeTourArea(int tourAreaId);

  Future<ApiResult<bool>> unlikeTourArea(int tourAreaId);
}

import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';

abstract class TourAreaDataSource {
  Future<ApiResult<TourAreaDetail>> getTourAreaDetail(int tourAreaId);
}

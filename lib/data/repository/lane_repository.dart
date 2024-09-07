import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';

abstract class LaneRepository {
  Future<ApiResult<LaneDetail>> getLaneDetail(int laneId);

  Future<ApiResult<bool>> likeLane(int laneId);

  Future<ApiResult<bool>> unlikeLane(int laneId);
}

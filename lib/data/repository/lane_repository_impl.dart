import 'package:gyeonggi_express/data/datasource/lane_datasource.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';

class LaneRepositoryImpl implements LaneRepository {
  final LaneDatasource _laneDataSource;

  LaneRepositoryImpl(this._laneDataSource);

  @override
  Future<ApiResult<LaneDetail>> getLaneDetail(int laneId) {
    return _laneDataSource.getLaneDetail(laneId);
  }

  @override
  Future<ApiResult<bool>> likeLane(int laneId) {
    return _laneDataSource.likeLane(laneId);
  }

  @override
  Future<ApiResult<bool>> unlikeLane(int laneId) {
    return _laneDataSource.unlikeLane(laneId);
  }
}

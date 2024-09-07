import 'package:gyeonggi_express/data/datasource/tour_area_datasource.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';

class TourAreaRepositoryImpl implements TourAreaRepository {
  final TourAreaDataSource _tourAreaDataSource;

  TourAreaRepositoryImpl(this._tourAreaDataSource);

  @override
  Future<ApiResult<TourAreaDetail>> getTourAreaDetail(int tourAreaId) {
    return _tourAreaDataSource.getTourAreaDetail(tourAreaId);
  }

  @override
  Future<ApiResult<bool>> likeTourArea(int tourAreaId) {
    return _tourAreaDataSource.likeTourArea(tourAreaId);
  }

  @override
  Future<ApiResult<bool>> unlikeTourArea(int tourAreaId) {
    return _tourAreaDataSource.unlikeTourArea(tourAreaId);
  }
}

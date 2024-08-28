import 'package:gyeonggi_express/data/datasource/favorite_datasource.dart';
import 'package:gyeonggi_express/data/datasource/favorite_datasource_impl.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteDataSource _favoriteDataSource;

  FavoriteRepositoryImpl(this._favoriteDataSource);

  @override
  Future<ApiResult<List<Lane>>> getFavoriteLanes() {
    return _favoriteDataSource.getFavoriteLanes();
  }

  @override
  Future<ApiResult<List<TourAreaSummary>>> getFavoriteTourAreas() {
    return _favoriteDataSource.getFavoriteTourAreas();
  }
}

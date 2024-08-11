import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';

import '../models/api_result.dart';

abstract class TripDataSource {

  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants();

  Future<ApiResult<List<PopularDestination>>> getPopularDestinations();

}
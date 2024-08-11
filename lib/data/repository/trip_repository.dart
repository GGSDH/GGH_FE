import '../models/api_result.dart';
import '../models/response/local_restaurant_response.dart';
import '../models/response/popular_destination_response.dart';

abstract class TripRepository {
  Future<ApiResult<List<LocalRestaurant>>> getLocalRestaurants();

  Future<ApiResult<List<PopularDestination>>> getPopularDestinations();
}
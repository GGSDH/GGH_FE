import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/keyword_search_result_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_keyword_response.dart';

abstract class SearchRepository {
  Future<ApiResult<List<PopularKeyword>>> getPopularKeywords();
  Future<ApiResult<List<KeywordSearchResult>>> search(String keyword);
}

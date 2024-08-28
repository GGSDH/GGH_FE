import 'package:dio/dio.dart';
import 'package:gyeonggi_express/data/datasource/search_datasource.dart';
import 'package:gyeonggi_express/data/ext/dio_extensions.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/keyword_search_result_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_keyword_response.dart';

class SearchDatasourceImpl implements SearchDatasource {
  final Dio _dio;

  SearchDatasourceImpl(this._dio);

  @override
  Future<ApiResult<List<PopularKeyword>>> getPopularKeywords() {
    return _dio.makeRequest<List<PopularKeyword>>(
        () => _dio.get('v1/trip/popularKeyword'),
        (data) => (data as List)
            .map((e) => PopularKeyword.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<ApiResult<List<KeywordSearchResult>>> search(String keyword) {
    return _dio.makeRequest<List<KeywordSearchResult>>(
        () => _dio.post('v1/trip/search', data: {'keyword': keyword}),
        (data) => (data as List)
            .map((e) => KeywordSearchResult.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

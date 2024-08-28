import 'package:gyeonggi_express/data/datasource/search_datasource.dart';
import 'package:gyeonggi_express/data/models/api_result.dart';
import 'package:gyeonggi_express/data/models/response/keyword_search_result_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_keyword_response.dart';
import 'package:gyeonggi_express/data/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource _searchDatasource;

  SearchRepositoryImpl(this._searchDatasource);

  @override
  Future<ApiResult<List<PopularKeyword>>> getPopularKeywords() {
    return _searchDatasource.getPopularKeywords();
  }

  @override
  Future<ApiResult<List<KeywordSearchResult>>> search(String keyword) {
    return _searchDatasource.search(keyword);
  }
}

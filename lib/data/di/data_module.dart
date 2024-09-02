import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/favorite_datasource.dart';
import 'package:gyeonggi_express/data/datasource/favorite_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/lane_datasource.dart';
import 'package:gyeonggi_express/data/datasource/lane_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/photobook_datasource.dart';
import 'package:gyeonggi_express/data/datasource/photobook_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/search_datasource.dart';
import 'package:gyeonggi_express/data/datasource/search_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/tour_area_datasource.dart';
import 'package:gyeonggi_express/data/datasource/tour_area_datasource_impl.dart';
import 'package:gyeonggi_express/data/datasource/trip_datasource.dart';
import 'package:gyeonggi_express/data/datasource/trip_datasource_impl.dart';
import 'package:gyeonggi_express/data/dio_client.dart';
import 'package:gyeonggi_express/data/repository/auth_repository.dart';
import 'package:gyeonggi_express/data/repository/auth_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';
import 'package:gyeonggi_express/data/repository/lane_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/search_repository.dart';
import 'package:gyeonggi_express/data/repository/search_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository_impl.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';
import 'package:gyeonggi_express/data/repository/trip_repository_impl.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_lane_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Register DataSources
  getIt.registerLazySingleton<AuthDataSource>(
        () => AuthDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<TripDataSource>(
        () => TripDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<PhotobookDataSource>(
        () => PhotobookDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<TourAreaDataSource>(
        () => TourAreaDataSourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<LaneDatasource>(
        () => LaneDatasourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<FavoriteDataSource>(
        () => FavoriteDatasourceImpl(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<SearchDatasource>(
        () => SearchDatasourceImpl(getIt<DioClient>().dio),
  );

  // Register Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthDataSource>()),
  );
  getIt.registerLazySingleton<TripRepository>(
        () => TripRepositoryImpl(getIt<TripDataSource>()),
  );
  getIt.registerLazySingleton<PhotobookRepository>(
        () => PhotobookRepositoryImpl(getIt<PhotobookDataSource>()),
  );
  getIt.registerLazySingleton<TourAreaRepository>(
        () => TourAreaRepositoryImpl(getIt<TourAreaDataSource>()),
  );
  getIt.registerLazySingleton<LaneRepository>(
        () => LaneRepositoryImpl(getIt<LaneDatasource>()),
  );
  getIt.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(getIt<FavoriteDataSource>()),
  );
  getIt.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(getIt<SearchDatasource>()),
  );

  // Register other services
  getIt.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
  );
}

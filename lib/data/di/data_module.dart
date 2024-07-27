import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gyeonggi_express/data/datasource/auth_datasource.dart';
import 'package:gyeonggi_express/data/dio_client.dart';
import 'package:gyeonggi_express/data/repository/auth_repository.dart';
import 'package:gyeonggi_express/data/repository/auth_repository_impl.dart';

import '../datasource/auth_datasource_impl.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(getIt<DioClient>().dio));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthDataSource>()));
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
}
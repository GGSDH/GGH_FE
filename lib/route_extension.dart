import 'package:gyeonggi_express/routes.dart';

extension RoutesExtension on Routes {
  String get path {
    switch (this) {
      case Routes.splash:
        return '/';
      case Routes.login:
        return '/login';
      case Routes.onboarding:
        return '/onboarding';
      case Routes.onboardingComplete:
        return '/onboarding/complete';

      case Routes.home:
        return '/home';
      case Routes.popularDestinations:
        return 'popular-destinations';
      case Routes.recommendedLanes:
        return 'recommended-lanes';
      case Routes.localRestaurants:
        return 'local-restaurants';

      case Routes.categoryDetail:
        return '/category-detail';
      case Routes.areaFilter:
        return '/area-filter';

      case Routes.stations:
        return '/stations';
      case Routes.lanes:
        return '/lanes';
      case Routes.recommend:
        return '/recommend';
      case Routes.photobook:
        return '/photobook';
      case Routes.addPhotobook:
        return 'add';
      case Routes.addPhotobookSelectPeriod:
        return 'add/select-period';
      case Routes.addPhotobookLoading:
        return 'add/loading';

      case Routes.myPage:
        return '/mypage';
      case Routes.myPageSetting:
        return 'setting';
      case Routes.myPageServicePolicy:
        return 'policy/service';
      case Routes.myPagePrivacyPolicy:
        return 'policy/privacy';
    }
  }
}
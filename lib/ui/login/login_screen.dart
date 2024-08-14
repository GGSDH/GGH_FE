import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/login/component/page_content.dart';
import 'package:gyeonggi_express/ui/login/login_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/repository/auth_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import 'component/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  final List<StatelessWidget> pages = List.generate(3, (index) => PageContent(pageIndex: index));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authRepository: GetIt.instance<AuthRepository>(),
        secureStorage: GetIt.instance<FlutterSecureStorage>(),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocSideEffectListener<LoginBloc, LoginSideEffect>(
            listener: (context, sideEffect) {
              if (sideEffect is LoginNavigateToHome) {
                GoRouter.of(context).go(Routes.home.path);
              } else if (sideEffect is LoginNavigateToOnboarding) {
                GoRouter.of(context).push(Routes.onboarding.path);
              } else if (sideEffect is LoginShowError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(sideEffect.message),
                  ),
                );
              }
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isLoading) {
                log("Login Loading");
              }
            },
          ),
        ],
        child: LoginScreenContent(
          pageViewController: _pageViewController,
          pages: pages,
        ),
      ),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  final PageController pageViewController;
  final List<StatelessWidget> pages;

  const LoginScreenContent({
    super.key,
    required this.pageViewController,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
          child: SmoothPageIndicator(
            controller: pageViewController,
            count: pages.length,
            effect: const SlideEffect(
              dotWidth: 10,
              dotHeight: 10,
              spacing: 10,
              dotColor: ColorStyles.gray300,
              activeDotColor: ColorStyles.gray800,
            ),
          ),
        ),
        PageView(
          controller: pageViewController,
          children: pages,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SocialLoginButton(
              loginType: SocialLoginType.KAKAO,
              onClick: () {
                BlocProvider.of<LoginBloc>(context).add(KakaoLoginButtonClicked());
              },
            ),
            const SizedBox(height: 14),

            SocialLoginButton(
              loginType: SocialLoginType.APPLE,
              onClick: () async {
                BlocProvider.of<LoginBloc>(context).add(AppleLoginButtonClicked());
              },
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                text: '첫 로그인 시, ', // 기본 스타일이 적용된 텍스트
                style: TextStyles.bodySmall.copyWith(
                  color: ColorStyles.gray500,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '서비스 이용약관', // 밑줄 텍스트
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '에 동의한 것으로 간주합니다', // 기본 스타일이 적용된 텍스트
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/login/component/page_content.dart';
import 'package:gyeonggi_express/ui/login/login_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/repository/auth_repository.dart';
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
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    _loginBloc = LoginBloc(
      authRepository: GetIt.instance.get<AuthRepository>(),
      secureStorage: GetIt.instance.get<FlutterSecureStorage>()
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
    _loginBloc.close();
  }

  final List<StatelessWidget> pages = List.generate(3, (index) => PageContent(pageIndex: index));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: MultiBlocListener(
        listeners: [
          BlocSideEffectListener<LoginBloc, LoginSideEffect>(
            listener: (context, sideEffect) {
              if (sideEffect is LoginNavigateToHome) {
                GoRouter.of(context).go('/home');
              } else if (sideEffect is LoginNavigateToSignUp) {
                GoRouter.of(context).go('/signup');
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
              if (state is LoginSuccess) {
                log("Login Success");
              } else if (state is LoginFailure) {
                log("Login Failure");
              } else {
                log("Login Loading");
              }
            },
          ),
        ],
        child: LoginScreenContent(
          pageViewController: _pageViewController,
          pages: pages,
          loginBloc: _loginBloc,
        ),
      ),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  final PageController pageViewController;
  final List<StatelessWidget> pages;
  final LoginBloc loginBloc;

  const LoginScreenContent({
    Key? key,
    required this.pageViewController,
    required this.pages,
    required this.loginBloc,
  }) : super(key: key);

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
                loginBloc.add(LoginButtonClicked());
              },
            ),
            const SizedBox(height: 14),
            SocialLoginButton(
              loginType: SocialLoginType.APPLE,
              onClick: () {
                log("Login with Google");
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

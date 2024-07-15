import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/ui/login/component/page_content.dart';
import 'package:gyeonggi_express/ui/login/login_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../themes/color_styles.dart';
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
    _loginBloc = LoginBloc();
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
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            log("Login Success");
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              )
            );
          }
        },
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
              child: SmoothPageIndicator(
                controller: _pageViewController,
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
                controller: _pageViewController,
                children: pages
            ),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SocialLoginButton(
                  loginType: SocialLoginType.KAKAO,
                  onClick: () {
                    _loginBloc.add(LoginButtonClicked());
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
                  text: const TextSpan(
                    text: '첫 로그인 시, ', // 기본 스타일이 적용된 텍스트
                    style: TextStyle(
                        color: ColorStyles.gray500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '서비스 이용약관', // 밑줄 텍스트
                        style: TextStyle(
                            decoration: TextDecoration.underline
                        ),
                      ),
                      TextSpan(
                        text: '에 동의한 것으로 간주합니다', // 기본 스타일이 적용된 텍스트
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24)
              ],
            )
          ]
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/onboarding_response.dart';
import '../../data/repository/auth_repository.dart';
import '../../routes.dart';
import '../../util/toast_util.dart';
import 'component/select_grid.dart';
import 'onboarding_bloc.dart';

class OnboardingScreen extends StatelessWidget {

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(
        authRepository: GetIt.instance.get<AuthRepository>(),
        secureStorage: GetIt.instance.get<FlutterSecureStorage>(),
      ),
      child: BlocSideEffectListener<OnboardingBloc, OnboardingSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is OnboardingComplete) {
            GoRouter.of(context).go(Routes.onboardingComplete.path);
          } else if (sideEffect is OnboardingShowError) {
            ToastUtil.showToast(context, sideEffect.message);
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return OnboardingScreenContent(
                selectedThemes: state.selectedThemes,
                themes: state.themes,
                onboardingBloc: context.read<OnboardingBloc>(),
              );
            }
          }
        )
      )
    );
  }
}

class OnboardingScreenContent extends StatelessWidget {
  final List<String> selectedThemes;
  final List<OnboardingTheme> themes;
  final OnboardingBloc onboardingBloc;

  const OnboardingScreenContent({
    super.key,
    required this.selectedThemes,
    required this.themes,
    required this.onboardingBloc
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppActionBar(
          onBackPressed: () { GoRouter.of(context).pop(); },
        ),
        Expanded(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "어떤 여행 테마를 선호하시나요?",
                      style: TextStyles.headlineXSmall,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "여행 테마를 선택해 주세요",
                      style: TextStyles.bodyLarge
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SelectableGrid(
                  items: themes.map(
                    (theme) => SelectableGridItemData(id: theme.name, emoji: theme.icon, title: theme.title)
                  ).toList(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14
                  ),
                  onSelectionChanged: (String themeId) {
                    BlocProvider.of<OnboardingBloc>(context).add(OnboardingSelectTheme(themeId));
                  },
                  selectedIds: selectedThemes,
                  maxSelection: themes.length,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              text: "다음",
              onPressed: () {
                BlocProvider.of<OnboardingBloc>(context).add(OnboardingNextButtonClicked(selectedThemes: selectedThemes));
              },
              isEnabled: selectedThemes.isNotEmpty,
              onIllegalPressed: () {
                ToastUtil.showToast(context, "여행 테마를 선택해 주세요");
              },
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/response/onboarding_response.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../themes/text_styles.dart';
import '../../component/app/app_action_bar.dart';
import '../../component/app/app_button.dart';
import '../../onboarding/component/select_grid.dart';
import 'add_photobook_select_theme_bloc.dart';

class AddPhotobookSelectThemeScreen extends StatelessWidget {

  const AddPhotobookSelectThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPhotobookSelectThemeBloc(
        authRepository: GetIt.instance.get<AuthRepository>(),
      ),
      child: BlocSideEffectListener<AddPhotobookSelectThemeBloc, AddPhotobookSelectThemeSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is AddPhotobookSelectThemeComplete) {
            GoRouter.of(context).go('/photobook/add/complete');
          } else if (sideEffect is AddPhotobookSelectThemeShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(sideEffect.message)
              )
            );
          }
        },
        child: BlocBuilder<AddPhotobookSelectThemeBloc, AddPhotobookSelectThemeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return AddPhotobookSelectThemeScreenContent(
                selectedThemes: state.selectedThemes,
                themes: state.themes,
                onboardingBloc: context.read<AddPhotobookSelectThemeBloc>(),
              );
            }
          }
        )
      )
    );
  }
}

class AddPhotobookSelectThemeScreenContent extends StatelessWidget {
  final List<String> selectedThemes;
  final List<OnboardingTheme> themes;
  final AddPhotobookSelectThemeBloc onboardingBloc;

  const AddPhotobookSelectThemeScreenContent({
    super.key,
    required this.selectedThemes,
    required this.themes,
    required this.onboardingBloc
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              rightText: "2/2",
              onBackPressed: () { GoRouter.of(context).pop(); },
              menuItems: const [],
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
                          "이번 여행의\n테마를 선택해 주세요",
                          style: TextStyles.headlineXSmall,
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
                        BlocProvider.of<AddPhotobookSelectThemeBloc>(context).add(AddPhotobookSelectThemeSelectTheme(themeId));
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
                    BlocProvider.of<AddPhotobookSelectThemeBloc>(context).add(AddPhotobookSelectThemeNextButtonClicked(selectedThemes: selectedThemes));
                  },
                  isEnabled: selectedThemes.isNotEmpty,
                  onIllegalPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('여행 테마를 선택해 주세요')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
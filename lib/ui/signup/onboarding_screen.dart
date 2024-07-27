import 'package:flutter/material.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/appbutton.dart';
import 'package:gyeonggi_express/ui/component/app_action_bar.dart';
import 'package:gyeonggi_express/ui/signup/component/select_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/signup/onboarding_steps.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;

  late List<List<String>> _selections;

  @override
  void initState() {
    super.initState();
    _selections = List.generate(signupSteps.length, (_) => []);
  }

  void _onSelectionChanged(String id) {
    setState(() {
      final currentSelections = _selections[_currentStep];
      final maxSelections = signupSteps[_currentStep]['maxSelections'] as int;

      if (currentSelections.contains(id)) {
        currentSelections.remove(id);
      } else if (currentSelections.length < maxSelections) {
        currentSelections.add(id);
      } else if (maxSelections == 1) {
        currentSelections.clear();
        currentSelections.add(id);
      }
    });
  }

  void _nextStep() {
    if (_currentStep < signupSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // 모든 단계 선택
      print('All selections: $_selections');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      // 뒤로 갈  수 없을 때?
    }
  }

  bool _isSelectionValid() {
    return _selections[_currentStep].isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = signupSteps[_currentStep];

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              rightText: '${_currentStep + 1}/${signupSteps.length}',
              onBackPressed: _previousStep,
              menuItems: const [],
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          currentStepData['question'],
                          style: TextStyles.headlineXSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(currentStepData['description'],
                            style: TextStyles.bodyLarge),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SelectableGrid(
                      items: currentStepData['items'],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      onSelectionChanged: _onSelectionChanged,
                      selectedIds: _selections[_currentStep],
                      maxSelection: currentStepData['maxSelections'],
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
                  text: _currentStep < signupSteps.length - 1 ? "다음" : "완료",
                  onPressed: _nextStep,
                  isEnabled: _isSelectionValid(),
                  onIllegalPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('선택을 완료해 주세요')),
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

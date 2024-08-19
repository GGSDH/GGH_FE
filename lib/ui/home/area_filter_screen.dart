import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class AreaFilterScreen extends StatefulWidget {
  const AreaFilterScreen({super.key});

  @override
  AreaFilterScreenState createState() => AreaFilterScreenState();
}

class AreaFilterScreenState extends State<AreaFilterScreen> {
  final Set<SigunguCode> _selectedAreas = <SigunguCode>{};

  final chips = SigunguCode.values.sublist(0, SigunguCode.values.length - 1);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
       child: SafeArea(
         child: Column(
           children: [
             AppActionBar(
               title: '지역 선택',
               onBackPressed: () => GoRouter.of(context).pop(),
               rightText: '',
               menuItems: const [],
             ),
             const SizedBox(height: 20),
             Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24
                ),
                child: Wrap(
                 spacing: 6,
                 runSpacing: 6,
                 children: chips.map((chip) => areaChip(chip)).toList(),
                ),
              ),
             ),
             Padding(
               padding: const EdgeInsets.all(14),
               child: AppButton(
                 text: '다음',
                 onPressed: () {

                 },
                 isEnabled: _selectedAreas.isNotEmpty,
               ),
             )
           ],
         ),
       ),
    );
  }

  Widget areaChip(SigunguCode code) {
    final isSelected = _selectedAreas.contains(code);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAreas.remove(code);
          } else {
            _selectedAreas.add(code);
          }
        });
      },
      child: Chip(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8
        ),
        shape : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: isSelected ? Colors.transparent : ColorStyles.gray600,
          ),
        ),
        label: Text(
          code.value,
          style: TextStyles.titleMedium.copyWith(
            color: isSelected ? Colors.white : ColorStyles.gray600
          )
        ),
        backgroundColor: isSelected ? ColorStyles.gray900 : ColorStyles.grayWhite,
      ),
    );
  }
}


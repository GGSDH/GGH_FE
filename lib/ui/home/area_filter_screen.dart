import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class AreaFilterScreen extends StatefulWidget {
  const AreaFilterScreen({super.key});

  AreaFilterScreenState createState() => AreaFilterScreenState();
}

class AreaFilterScreenState extends State<AreaFilterScreen> {
  final Set<String> _selectedAreas = <String>{};

  final chips = [
    "전체", "가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "남양주시", "동두천시", "부천시", "성남시",
    "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시"
  ];

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

  Widget areaChip(String label) {
    final isSelected = _selectedAreas.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAreas.remove(label);
          } else {
            _selectedAreas.add(label);
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
          label,
          style: TextStyles.titleMedium.copyWith(
            color: isSelected ? Colors.white : ColorStyles.gray600
          )
        ),
        backgroundColor: isSelected ? ColorStyles.gray900 : ColorStyles.grayWhite,
      ),
    );
  }
}


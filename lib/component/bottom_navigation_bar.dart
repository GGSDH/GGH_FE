import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../themes/color_styles.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTap(index);
  }

  Widget _buildNavItem({required int index, required String selectedIconPath, required String unselectedIconPath, required String label}) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected ? selectedIconPath : unselectedIconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? ColorStyles.gray900 : ColorStyles.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorStyles.gray500.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 77,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  selectedIconPath: 'assets/icons/ic_home_selected.svg',
                  unselectedIconPath: 'assets/icons/ic_home_unselected.svg',
                  label: '홈',
                ),
                _buildNavItem(
                  index: 1,
                  selectedIconPath: 'assets/icons/ic_recommend_selected.svg',
                  unselectedIconPath: 'assets/icons/ic_recommend_unselected.svg',
                  label: 'AI추천',
                ),
                _buildNavItem(
                  index: 2,
                  selectedIconPath: 'assets/icons/ic_photo_book_selected.svg',
                  unselectedIconPath: 'assets/icons/ic_photo_book_unselected.svg',
                  label: '포토북',
                ),
                _buildNavItem(
                  index: 3,
                  selectedIconPath: 'assets/icons/ic_mypage_selected.svg',
                  unselectedIconPath: 'assets/icons/ic_mypage_unselected.svg',
                  label: '마이',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class MyPageSettingScreen extends StatefulWidget {
  const MyPageSettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageSettingScreenState();
}

class _MyPageSettingScreenState extends State<MyPageSettingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(
              onTapBack: () {
                context.pop();
              },
            ),
            _buildProfileImageSection(),
            _buildProfileIdSection(),
            _buildNicknameSection(),
            const Spacer(),
            _buildSaveButton(
              () {
                context.pop();
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar({required Function() onTapBack}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onTapBack,
              child: SvgPicture.asset(
                'assets/icons/ic_arrow_back.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Center(
            child: Text(
              "내정보",
              style: TextStyles.titleLarge.copyWith(
                color: ColorStyles.gray900
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_default_profile.svg',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIdSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
            child: Row(
              children: [
                Text(
                  '아이디',
                  style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray800,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "카카오로 가입한 계정이에요.",
                  style: TextStyles.bodySmall.copyWith(
                    color: ColorStyles.gray500,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: "yena009@naver.com",
              hintStyle: TextStyles.bodyLarge.copyWith(
                color: ColorStyles.gray500,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray50,
                  width: 1,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray50,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: TextStyles.bodyLarge.copyWith(
              color: ColorStyles.gray800,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: "닉네임을 입력해주세요",
              hintStyle: TextStyles.bodyLarge.copyWith(
                color: ColorStyles.gray500,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray200,
                  width: 1,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray900,
                  width: 1,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray200,
                  width: 1,
                ),
              ),
              suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/ic_clear.svg",
                    width: 20,
                    height: 20,
                  ),
                )
                : null
            ),
            style: TextStyles.bodyLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    final isValid = _controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
              backgroundColor: isValid ? ColorStyles.primary : ColorStyles.gray100,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
          ),
          child: Text(
            "변경사항 저장",
            style: TextStyles.titleMedium.copyWith(
              color: isValid ? Colors.white : ColorStyles.gray500,
            ),
          ),
        ),
      ),
    );
  }
}
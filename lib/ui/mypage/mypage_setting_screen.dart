import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../themes/color_styles.dart';

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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  child: const Text(
                    "완료",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
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
          const Center(
            child: Text(
              "내정보",
              style: TextStyle(
                color: ColorStyles.gray900,
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "홍길동",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: ColorStyles.gray900,
                ),
              ),
              SizedBox(width: 6),
              Text(
                "님",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: ColorStyles.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIdSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 8),
            child: Row(
              children: [
                Text(
                  '아이디',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ColorStyles.gray800,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "카카오로 가입한 계정이에요.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.gray500,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: "yena009@naver.com",
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorStyles.gray500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray200,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adding borderRadius to round the edges
                borderSide: BorderSide(
                  color: ColorStyles.gray200,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
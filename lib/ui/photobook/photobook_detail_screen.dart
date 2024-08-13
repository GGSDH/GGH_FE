import 'package:flutter/material.dart';

import '../../themes/text_styles.dart';

class PhotobookDetailScreen extends StatefulWidget {
  @override
  _PhotobookDetailScreenState createState() => _PhotobookDetailScreenState();
}

class _PhotobookDetailScreenState extends State<PhotobookDetailScreen> {
  int currentPage = 0;
  final int pageCount = 5;
  double baseCardWidth = 350.0;
  double baseCardHeight = 480.0;
  double scaleFactor = 0.9; // 각 페이지가 멀어질수록 크기 줄어드는 비율
  double visiblePartHeight = 20.0; // 겹치지 않는 부분의 높이
  double swipeOffset = 0.0;
  bool isSwiping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = pageCount - 1; i >= currentPage; i--)
              _buildCard(i), // 현재 페이지부터 페이지들을 역순으로 쌓음
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: calculateBottomOffset(index) + (index == currentPage ? swipeOffset : 0),
      width: calculateCardWidth(index),
      height: calculateCardHeight(index),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            swipeOffset += details.delta.dy; // 스와이프 방향으로 페이지 이동
          });
        },
        onVerticalDragEnd: (details) => _onVerticalDragEnd(details),
        child: Opacity(
          opacity: calculateOpacity(index),
          child: Page(index: index),
        ),
      ),
    );
  }

  double calculateBottomOffset(int index) {
    double offsetFromCenter = (index - currentPage).toDouble();

    // 중앙에 위치시키기 위한 계산
    double baseOffset = MediaQuery.of(context).size.height / 2 - baseCardHeight / 1.5;

    // 선택된 페이지는 중앙에 위치, 나머지는 상대적으로 위치
    return baseOffset - offsetFromCenter * visiblePartHeight;
  }

  double calculateCardWidth(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardWidth * scale;
  }

  double calculateCardHeight(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardHeight * scale;
  }

  double calculateOpacity(int index) {
    double maxOpacityDecrease = 0.5; // 가장 멀리 있는 페이지의 최소 투명도
    double opacity = 1 - ((index - currentPage).abs() * maxOpacityDecrease);
    if ((index - currentPage).abs() > 2) return 0;
    return opacity.clamp(0.5, 1.0);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0 && currentPage < pageCount - 1) {
      // 아래 -> 위로 스와이프 (다음 페이지로 이동)
      setState(() {
        swipeOffset = MediaQuery.of(context).size.height; // 페이지를 아래로 이동
        isSwiping = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentPage++;
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else if (details.primaryVelocity! > 0 && currentPage > 0) {
      // 위 -> 아래로 스와이프 (이전 페이지로 이동)
      setState(() {
        swipeOffset = -MediaQuery.of(context).size.height; // 페이지를 위로 이동
        isSwiping = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentPage--;
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else {
      setState(() {
        swipeOffset = 0.0; // 스와이프 취소 시 초기화
      });
    }
  }
}

class Page extends StatelessWidget {
  final int index;

  Page({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'DAY ${index + 1}',
          style: TextStyles.displaySmall.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

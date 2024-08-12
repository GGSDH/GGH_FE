import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../component/app/app_action_bar.dart';

class PhotobookDetailScreen extends StatefulWidget {

  @override
  _PhotobookDetailScreenState createState() => _PhotobookDetailScreenState();
}

class _PhotobookDetailScreenState extends State<PhotobookDetailScreen> {
  final _cardSwipeController = CardSwiperController();

  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: const Text('1'),
      color: Colors.blue,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('2'),
      color: Colors.red,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('3'),
      color: Colors.purple,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('4'),
      color: Colors.green,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('5'),
      color: Colors.yellow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 350,  // Specify the width you desire
          height: 400, // Specify the height you desire
          child: CardSwiper(
            cardsCount: cards.length,
            controller: _cardSwipeController,
            numberOfCardsDisplayed: 2,
            cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
            allowedSwipeDirection: const AllowedSwipeDirection.only(
              down: true,
              up: true,
            )
          ),
        ),
      ),
    );
  }
}

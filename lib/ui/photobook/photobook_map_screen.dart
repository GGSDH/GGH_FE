import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/repository/photobook_repository.dart';
import '../../util/naver_map_util.dart';

class PhotobookMapScreen extends StatefulWidget {
  final String photobookId;

  const PhotobookMapScreen({
    super.key,
    required this.photobookId,
  });

  @override
  _PhotobookMapScreenState createState() => _PhotobookMapScreenState();
}

class _PhotobookMapScreenState extends State<PhotobookMapScreen> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer<NaverMapController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotobookDetailBloc(
        photobookRepository: GetIt.instance<PhotobookRepository>(),
      )..add(PhotobookDetailInitialize(int.parse(widget.photobookId))),
      child: BlocSideEffectListener<PhotobookDetailBloc, PhotobookDetailSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is PhotobookDetailShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(sideEffect.message)),
            );
          }
        },
        child: BlocBuilder<PhotobookDetailBloc, PhotobookDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    AppActionBar(
                      onBackPressed: () => GoRouter.of(context).pop(),
                    ),
                    Expanded(
                      child: _MapSection(
                        mapControllerCompleter: _mapControllerCompleter,
                        photobookDetailCards: state.photobookDetailCards,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({
    required this.mapControllerCompleter,
    required this.photobookDetailCards,
  });

  final Completer<NaverMapController> mapControllerCompleter;
  final List<PhotobookDetailCard> photobookDetailCards;

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        initialCameraPosition: Constants.DEFAULT_CAMERA_POSITION,
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
        rotationGesturesEnable: true,
        scrollGesturesEnable: true,
        zoomGesturesEnable: true,
      ),
      onMapReady: (controller) async {
        if (!mapControllerCompleter.isCompleted) {
          mapControllerCompleter.complete(controller);
        }

        await NaverMapUtil.addMarkersAndPath(controller, photobookDetailCards, context);
      },
    );
  }
}

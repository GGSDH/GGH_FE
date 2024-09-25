import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../util/naver_map_util.dart';
import '../../util/toast_util.dart';

class PhotobookMapScreen extends StatefulWidget {

  const PhotobookMapScreen({
    super.key,
  });

  @override
  _PhotobookMapScreenState createState() => _PhotobookMapScreenState();
}

class _PhotobookMapScreenState extends State<PhotobookMapScreen> {
  NaverMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PhotobookDetailBloc, PhotobookDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PhotobookDetailShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        }
      },
      child: BlocBuilder<PhotobookDetailBloc, PhotobookDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  AppActionBar(
                    onBackPressed: () => GoRouter.of(context).pop(),
                  ),
                  Expanded(
                    child: _mapSection(
                      photobookDetailCards: state.photobookDetailCards,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mapSection({
    required List<PhotobookDetailCard> photobookDetailCards,
  }) {
    void addMarkersAndPath(NaverMapController controller) async {
      if (_mapController == null) return;
      await NaverMapUtil.addMarkersAndPath(controller, photobookDetailCards, context);
    }

    if (_mapController != null) {
      addMarkersAndPath(_mapController!);
    }

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
        _mapController = controller;
        addMarkersAndPath(controller);
      },
    );
  }
}
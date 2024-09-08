import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({
    required this.title,
    required this.url,
    super.key
  });

  @override
  State<StatefulWidget> createState() => _MyPagePolicyScreenState();
}

class _MyPagePolicyScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
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
                GoRouter.of(context).pop();
              },
            ),
            Expanded(
              child: WebViewWidget(
                  controller: _webViewController
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
          Center(
            child: Text(
              widget.title,
              style: TextStyles.titleLarge.copyWith(
                  color: ColorStyles.gray900
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../themes/color_styles.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    required this.text,
    this.trimLines = 2,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveTextStyle =
        widget.style ?? const TextStyle(color: ColorStyles.primary);
    final linkText = _isExpanded ? ' ...접기' : ' ...더보기';
    final linkTextStyle = effectiveTextStyle.copyWith(
      color: ColorStyles.primary,
      fontWeight: FontWeight.w400,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: effectiveTextStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
          minWidth: 0,
          maxWidth: constraints.maxWidth,
        );

        bool isTextOverflowing = textPainter.didExceedMaxLines;

        if (isTextOverflowing) {
          return _isExpanded
              ? RichText(
            text: TextSpan(
              text: widget.text,
              style: effectiveTextStyle,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      linkText,
                      style: linkTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
              : RichText(
            text: TextSpan(
              text: _trimText(widget.text, linkText, constraints.maxWidth,
                  effectiveTextStyle, linkTextStyle),
              style: effectiveTextStyle,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      linkText,
                      style: linkTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text(widget.text, style: effectiveTextStyle);
        }
      },
    );
  }

  // 텍스트를 잘라내는 함수
  String _trimText(String text, String linkText, double maxWidth,
      TextStyle textStyle, TextStyle linkStyle) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final linkSpan = TextSpan(text: linkText, style: linkStyle);

    final linkPainter = TextPainter(
      text: linkSpan,
      textDirection: TextDirection.ltr,
    );
    linkPainter.layout(minWidth: 0, maxWidth: maxWidth);

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: maxWidth - linkPainter.width);

    int endIndex = textPainter.getPositionForOffset(Offset(
      textPainter.width,
      textPainter.height,
    )).offset;

    return text.substring(0, endIndex).trim();
  }
}

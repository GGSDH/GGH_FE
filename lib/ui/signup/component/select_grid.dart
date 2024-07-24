import 'package:flutter/material.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class SelectableGrid extends StatelessWidget {
  final List<SelectableGridItemData> items;
  final EdgeInsets padding;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Function(String) onSelectionChanged;
  final List<String> selectedIds;
  final int maxSelection;

  const SelectableGrid({
    super.key,
    required this.items,
    required this.padding,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 20.0,
    required this.onSelectionChanged,
    required this.selectedIds,
    required this.maxSelection,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing) /
                crossAxisCount;
        const double itemHeight = 175;
        final double childAspectRatio = itemWidth / itemHeight;

        return SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildGridItem(item);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridItem(SelectableGridItemData item) {
    final bool isSelected = selectedIds.contains(item.id);

    return GestureDetector(
      onTap: () {
        onSelectionChanged(item.id);
      },
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorStyles.primary.withOpacity(0.1)
                  : ColorStyles.gray50,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: isSelected ? ColorStyles.primary : ColorStyles.gray100,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                item.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            item.title,
            style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray800),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SelectableGridItemData {
  final String id;
  final String emoji;
  final String title;

  SelectableGridItemData(
      {required this.id, required this.emoji, required this.title});
}

import 'package:flutter/material.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';

class SelectableGrid extends StatefulWidget {
  final List<SelectableGridItemData> items;
  final EdgeInsets padding;

  const SelectableGrid(
      {super.key, required this.items, this.padding = EdgeInsets.zero});

  @override
  State<SelectableGrid> createState() => _SelectableGridState();
}

class _SelectableGridState extends State<SelectableGrid> {
  final List<String> _selectedIds = [];
  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: GridView.builder(
        itemCount: widget.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return GestureDetector(
              onTap: () => _toggleSelection(item.id),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    decoration: BoxDecoration(
                        color: ColorStyles.gray50,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _selectedIds.contains(item.id)
                              ? ColorStyles.primary
                              : ColorStyles.gray100,
                          width: 1.0,
                        )),
                    child: Icon(item.icon),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorStyles.gray800),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class SelectableGridItemData {
  final String id;
  final IconData icon;
  final String title;

  SelectableGridItemData(
      {required this.id, required this.icon, required this.title});
}

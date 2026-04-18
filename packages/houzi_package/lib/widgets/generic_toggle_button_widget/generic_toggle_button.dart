import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef OnToggleSelected = void Function(String selectedValue);

class GenericToggleButtonWidget extends StatefulWidget {
  final List<String> labels; 
  final List<String> values; 
  final OnToggleSelected onSelected; 
  final String? initialValue;
  final Color selectedColor; 
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final Color selectedBorderColor;
  final double? buttonWidth;
  final double buttonHeight;

  const GenericToggleButtonWidget({
    Key? key,
    required this.labels,
    required this.values,
    required this.onSelected,
    this.initialValue,
    this.buttonHeight = 40.0,
    this.borderWidth = 1.5, 
    required this.selectedColor, 
    required this.fillColor, 
    required this.borderColor, 
    required this.selectedBorderColor,
    this.buttonWidth,
  }) : super(key: key);

  @override
  _GenericToggleButtonWidgetState createState() => _GenericToggleButtonWidgetState();
}

class _GenericToggleButtonWidgetState extends State<GenericToggleButtonWidget> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    int initialIndex = widget.initialValue != null
        ? widget.values.indexOf(widget.initialValue!)
        : 0;

    isSelected = List<bool>.generate(widget.labels.length, (index) => index == initialIndex);
  }

  void handleSelection(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
    widget.onSelected(widget.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30),
        selectedColor: widget.selectedColor,
        fillColor: widget.fillColor,
        borderColor: widget.borderColor,
        selectedBorderColor: widget.selectedBorderColor,
        borderWidth: widget.borderWidth,
        isSelected: isSelected,
        onPressed: handleSelection,
        children: widget.labels.map((label) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString(label),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
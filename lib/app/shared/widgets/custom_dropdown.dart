import '../../core/appExports/app_export.dart';


class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;
  final bool isExpanded;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color borderColor;
  final Color? backGroundColor;
  final Color dropdownColor;
  final FormFieldValidator<String>? validator;
  final String? label;
  final bool readOnly;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.validator,
    this.selectedValue,
    this.hintText = "Enter",
    this.isExpanded = true,
    this.buttonHeight,
    this.buttonWidth,
    this.borderColor = Colors.grey,
    this.dropdownColor = Colors.white,
    this.label,
    required double borderRadius,
    this.backGroundColor,
    this.readOnly = false,
  });

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    _updateSelectedItem(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != selectedItem) {
      _updateSelectedItem(widget.selectedValue);
    }
  }

  // Helper method to validate and update selected item
  void _updateSelectedItem(String? value) {
    if (value != null && widget.items.contains(value)) {
      setState(() {
        selectedItem = value;
      });
    } else {
      setState(() {
        selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: REdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.label ?? "",
              style: AppFontStyle.text_14_500(
                AppColors.darkText,
                fontFamily: AppFontFamily.medium,
              ),
            ),
          ),
        IgnorePointer(
          ignoring: widget.readOnly,
          child: DropdownButtonFormField2<String>(
            decoration: InputDecoration(
              filled: true,
              errorStyle: AppFontStyle.text_12_400(Colors.red),
              fillColor: widget.backGroundColor ?? AppColors.fieldBgColor,
              contentPadding: REdgeInsets.symmetric(horizontal: 5, vertical: 14),
              border: Get.defaultBorder(60.r),
              enabledBorder: Get.defaultBorder(60.r),
              focusedBorder: Get.focusedBorder(60.r),
              errorBorder: Get.errorBorder(60.r),
            ),
            isDense: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            isExpanded: widget.isExpanded,
            hint: Text(
              widget.hintText,
              style: AppFontStyle.text_13_400(AppColors.hintText),
            ),
            items: widget.items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppFontStyle.text_14_400(AppColors.darkText),
                ),
              );
            }).toList(),
            value: selectedItem,
            onChanged: widget.readOnly
                ? null
                : (String? value) {
              setState(() {
                selectedItem = value;
              });
              widget.onChanged(value);
            },
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: REdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 22,
                  color: AppColors.darkText,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.fieldBgColor,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(6),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40,
              padding: REdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
    );
  }
}



class CustomDropDownT<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final Function(T?) onChanged;
  final String hintText;
  final bool isExpanded;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color borderColor;
  final Color? backGroundColor;
  final Color dropdownColor;
  final FormFieldValidator<T>? validator;
  final String? label;
  final bool readOnly;

  const CustomDropDownT({
    super.key,
    required this.items,
    required this.onChanged,
    required this.validator,
    this.selectedValue,
    this.hintText = "Enter",
    this.isExpanded = true,
    this.buttonHeight,
    this.buttonWidth,
    this.borderColor = Colors.grey,
    this.dropdownColor = Colors.white,
    this.label,
    required double borderRadius,
    this.backGroundColor,
    this.readOnly = false,
  });

  @override
  _CustomDropDownStateT<T> createState() => _CustomDropDownStateT<T>();
}

class _CustomDropDownStateT<T> extends State<CustomDropDownT<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    _updateSelectedItem(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant CustomDropDownT<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != selectedItem) {
      _updateSelectedItem(widget.selectedValue);
    }
  }

  // Helper method to validate and update selected item
  void _updateSelectedItem(T? value) {
    if (value != null && widget.items.contains(value)) {
      setState(() {
        selectedItem = value;
      });
    } else {
      setState(() {
        selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.label ?? "",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        IgnorePointer(
          ignoring: widget.readOnly,
          child: DropdownButtonFormField2<T>(
            decoration: InputDecoration(
                filled: true,
                errorStyle: AppFontStyle.text_12_400(Colors.red),
                fillColor: widget.backGroundColor ?? AppColors.fieldBgColor,
                contentPadding: REdgeInsets.symmetric(horizontal: 5, vertical: 14),
                border: Get.defaultBorder(60.r),
                enabledBorder: Get.defaultBorder(60.r),
                focusedBorder: Get.focusedBorder(60.r),
                errorBorder: Get.errorBorder(60.r),
            ),
            isDense: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            isExpanded: widget.isExpanded,
            hint: Text(
              widget.hintText,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            items: widget.items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              );
            }).toList(),
            value: selectedItem,
            onChanged: widget.readOnly
                ? null
                : (T? value) {
              setState(() {
                selectedItem = value;
              });
              widget.onChanged(value);
            },
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: REdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 22,
                  color: AppColors.darkText,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.fieldBgColor,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(6),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40,
              padding: REdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
    );
  }
}

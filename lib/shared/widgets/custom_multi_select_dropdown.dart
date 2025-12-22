import 'package:dropdown_button2/dropdown_button2.dart';
import '../../core/appExports/app_export.dart';

class CustomMultiSelectDropDown extends StatefulWidget {
  final List<String> items;
  final List<String>? selectedValues;
  final Function(List<String>) onChanged;
  final String hintText;
  final bool isExpanded;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color borderColor;
  final Color? backGroundColor;
  final Color dropdownColor;
  final FormFieldValidator<List<String>>? validator;
  final String? label;
  final bool readOnly;
  final int? maxSelections;

  const CustomMultiSelectDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.validator,
    this.selectedValues,
    this.hintText = "Select items",
    this.isExpanded = true,
    this.buttonHeight,
    this.buttonWidth,
    this.borderColor = Colors.transparent,
    this.dropdownColor = Colors.white,
    this.label,
    required double borderRadius,
    this.backGroundColor,
    this.readOnly = false,
    this.maxSelections,
  });

  @override
  _CustomMultiSelectDropDownState createState() => _CustomMultiSelectDropDownState();
}

class _CustomMultiSelectDropDownState extends State<CustomMultiSelectDropDown> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedValues != null) {
      selectedItems = List.from(widget.selectedValues!);
    }
  }

  @override
  void didUpdateWidget(covariant CustomMultiSelectDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != null &&
        widget.selectedValues != selectedItems) {
      setState(() {
        selectedItems = List.from(widget.selectedValues!);
      });
    }
  }

  void _toggleSelection(String value) {
    setState(() {
      if (selectedItems.contains(value)) {
        selectedItems.remove(value);
      } else {
        if (widget.maxSelections == null ||
            selectedItems.length < widget.maxSelections!) {
          selectedItems.add(value);
        }
      }
    });
    widget.onChanged(selectedItems);
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
    });
    widget.onChanged(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: selectedItems,
      validator: widget.validator,
      builder: (formState) {
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

            if (selectedItems.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: REdgeInsets.only(bottom: 8),
                padding: REdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.fieldBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.dividerColor,
                    width: 1,
                  ),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedItems.map((item) {
                    return Container(
                      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryLast,
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: AppFontStyle.text_12_500(
                              AppColors.white,
                              fontFamily: AppFontFamily.medium,
                            ),
                          ),
                          wBox(4),
                          GestureDetector(
                            onTap: widget.readOnly
                                ? null
                                : () {
                              _removeItem(item);
                              formState.didChange(selectedItems);
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            IgnorePointer(
              ignoring: widget.readOnly,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: widget.isExpanded,
                  hint: Text(
                    widget.hintText,
                    style: AppFontStyle.text_13_400(AppColors.hintText),
                  ),
                  items: widget.items.map((String item) {
                    final isSelected = selectedItems.contains(item);
                    return DropdownMenuItem<String>(
                      value: item,
                      enabled: !widget.readOnly,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: REdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                      : null,
                                ),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: AppFontStyle.text_14_400(
                                      isSelected
                                          ? AppColors.primary
                                          : AppColors.darkText,
                                      fontFamily: isSelected
                                          ? AppFontFamily.medium
                                          : AppFontFamily.regular,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: null,
                  onChanged: widget.readOnly
                      ? null
                      : (String? value) {
                    if (value != null) {
                      _toggleSelection(value);
                      formState.didChange(selectedItems);
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    height: widget.buttonHeight ?? 50,
                    width: widget.buttonWidth,
                    padding: REdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.r),
                      border: Border.all(
                        color: widget.borderColor,
                      ),
                      color:
                      widget.backGroundColor ?? AppColors.fieldBgColor,
                    ),
                  ),
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
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.fieldBgColor,
                    ),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all<double>(6),
                      thumbVisibility: WidgetStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: 50,
                    padding: REdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
            ),

            if (formState.hasError)
              Padding(
                padding: REdgeInsets.only(top: 8, left: 14),
                child: Text(
                  formState.errorText ?? '',
                  style: AppFontStyle.text_12_400(Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
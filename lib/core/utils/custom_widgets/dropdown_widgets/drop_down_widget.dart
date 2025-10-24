/*
import 'package:flutter/material.dart';
import 'package:dropdown_model_list/drop_down/select_drop_list.dart';

class ReusableDropdown<T> extends StatelessWidget {
  final OptionItems<T>? selectedItem;
  final DropdownListModel<T> dropListModel;
  final Function(OptionItems<T>) onOptionSelected;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;         // prefix// suffix

  const ReusableDropdown({
    super.key,
    required this.selectedItem,
    required this.dropListModel,
    required this.onOptionSelected,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus(); // closes any dropdown/focus when tapping outside
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Text(
              labelText!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 0),
          ],

          FocusScope(
            child: SelectDropList<T>(
              icon: prefixIcon ?? null,
              itemSelected: selectedItem,
              dropListModel: dropListModel,
              onOptionSelected: onOptionSelected,
              hintText: hintText,
              showArrowIcon: true,
              height: 44,
              arrowColor: Colors.black,
              textColorTitle: Colors.black,
              textColorItem: Colors.black,
              dropboxColor: Colors.white,
              dropBoxBorderColor: Colors.grey,
              scrollThumbColor: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
*/

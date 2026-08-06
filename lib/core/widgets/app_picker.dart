import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_colors.dart';
import 'package:lift_log/core/widgets/app_text.dart';

class AppPicker {
  AppPicker._();

  static Future<T?> show<T>({
    required BuildContext context,
    required List<T> items,
    required String Function(T item) itemLabel,
    required String pickerTitle,
    T? initialValue,
  }) async {
    T? selected = initialValue ?? items.first;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final initialIndex = initialValue == null
            ? 0
            : items.indexOf(initialValue);

        return Container(
          height: 300,
          color: AppColors.black,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: null,
                    child: AppText(
                      pickerTitle.tr,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                  CupertinoButton(
                    child: AppText("done".tr),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),

              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,

                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    selected = items[index];
                  },
                  children: items
                      .map(
                        (e) => Center(
                          child: AppText(
                            itemLabel(e).tr,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    return selected;
  }
}

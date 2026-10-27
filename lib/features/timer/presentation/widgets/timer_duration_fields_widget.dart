import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';

class TimerDurationFieldsWidget extends StatefulWidget {
  const TimerDurationFieldsWidget({
    required this.initialDuration,
    required this.onDurationChanged,
    super.key,
  });

  final Duration initialDuration;
  final ValueChanged<Duration> onDurationChanged;

  @override
  State<TimerDurationFieldsWidget> createState() =>
      _TimerDurationFieldsWidgetState();
}

class _TimerDurationFieldsWidgetState extends State<TimerDurationFieldsWidget> {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController();
    _minutesController = TextEditingController();
    _secondsController = TextEditingController();
    _writeDuration(widget.initialDuration);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = _durationFromFields;
    final hasInvalidRange = duration == null && _hasEnteredValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          'set_countdown'.tr,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: context.appColors.subtitle,
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                label: 'hours'.tr,
                child: AppTextField(
                  controller: _hoursController,
                  keyboardType: TextInputType.number,
                  hint: '00',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: (_) => _handleChanged(),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: LabeledTextField(
                label: 'minutes'.tr,
                child: AppTextField(
                  controller: _minutesController,
                  keyboardType: TextInputType.number,
                  hint: '00',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (_) => _handleChanged(),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: LabeledTextField(
                label: 'seconds'.tr,
                child: AppTextField(
                  controller: _secondsController,
                  keyboardType: TextInputType.number,
                  hint: '00',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (_) => _handleChanged(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _quickDurationChip(context, 30, 'sec'),
            _quickDurationChip(context, 60, 'min'),
            _quickDurationChip(context, 300, 'min'),
            _quickDurationChip(context, 600, 'min'),
            _quickDurationChip(context, 1800, 'min'),
          ],
        ),
        if (hasInvalidRange) ...[
          SizedBox(height: AppSpacing.sm),
          AppText(
            'invalid_timer_duration'.tr,
            fontSize: 12.sp,
            color: context.colors.error,
          ),
        ],
      ],
    );
  }

  Widget _quickDurationChip(BuildContext context, int seconds, String unit) {
    final value = unit == 'sec' ? seconds : seconds ~/ 60;
    return ActionChip(
      label: AppText(
        '$value ${unit.tr}',
        color: context.colors.onSurface,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
      onPressed: () {
        _hoursController.text = '00';
        _minutesController.text = (seconds ~/ 60).toString().padLeft(2, '0');
        _secondsController.text = (seconds % 60).toString().padLeft(2, '0');
        _handleChanged();
      },
    );
  }

  Duration? get _durationFromFields {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    if (minutes > 59 || seconds > 59) return null;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  bool get _hasEnteredValue =>
      _hoursController.text.isNotEmpty ||
      _minutesController.text.isNotEmpty ||
      _secondsController.text.isNotEmpty;

  void _writeDuration(Duration duration) {
    _hoursController.text = duration.inHours.toString().padLeft(2, '0');
    _minutesController.text = (duration.inMinutes % 60).toString().padLeft(
      2,
      '0',
    );
    _secondsController.text = (duration.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );
  }

  void _handleChanged() {
    setState(() {});
    widget.onDurationChanged(_durationFromFields ?? Duration.zero);
  }
}

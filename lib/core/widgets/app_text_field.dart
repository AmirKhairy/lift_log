import 'package:flutter/material.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.filled = true,
    this.fillColor,
    this.hintColor,
    this.obscureIconColor,
    this.textColor,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hint;

  final String? Function(String?)? validator;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final VoidCallback? onSuffixPressed;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final int maxLines;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;

  final TextCapitalization textCapitalization;

  final bool filled;
  final Color? fillColor;
  final Color? hintColor;
  final Color? obscureIconColor;
  final Color? textColor;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.textColor ?? AppColors.textDark),
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      obscureText: _obscure,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        hintText: widget.hint?.tr,
        hintStyle: TextStyle(color: widget.hintColor ?? AppColors.textDark),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: widget.obscureIconColor ?? AppColors.white,
                ),
              )
            : widget.suffixIcon == null
            ? null
            : IconButton(
                onPressed: widget.onSuffixPressed,
                icon: widget.suffixIcon!,
              ),
        filled: widget.filled,
        fillColor: widget.fillColor ?? AppColors.backgroundLight,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../utils/global_colors.dart';
import 'text_style.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isObscure;
  final bool? enabled;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isObscure = false,
    this.enabled,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late ValueNotifier<bool> _hasValue;

  @override
  void initState() {
    super.initState();
    _hasValue = ValueNotifier<bool>(widget.controller.text.trim().isNotEmpty);

    widget.controller.addListener(() {
      _hasValue.value = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _hasValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _hasValue,
      builder: (context, hasValue, _) {
        final borderColor = hasValue ?AppColors.primaryColor: Colors.grey.shade400;
        final labelColor = hasValue ?AppColors.primaryColor :AppColors.formLabelColor;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: appTextStyle(
                  font: 'lexend',
                  //letterSpacing:1,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),

              ),
              TextFormField(
                controller: widget.controller,
                obscureText: widget.isObscure,
                enabled: widget.enabled ?? true,
                readOnly: widget.readOnly ?? false,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: InputBorder.none,
                  isDense: true,
                  counterText: "",
                  contentPadding: const EdgeInsets.only(top: 6),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  prefix: widget.prefix,
                  suffix: widget.suffix,
                  hintStyle: appTextStyle(
                    font: 'lexend',
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.formHintColor,)
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

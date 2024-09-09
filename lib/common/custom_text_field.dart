import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:userapp/common/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FaIcon? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? val)? validator;
  final bool? isSecureText;
  final VoidCallback? suffixIconPressed;
  final VoidCallback? prefixIconPressed;
  final bool? enabled;
  final bool? readOnly;
  final int? maxLine;
  final int? maxCharacter;
  final int? minCharacter;
  final VoidCallback? onTap;
  final TextStyle? style;
  final bool? obsucure;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconPressed,
    this.validator,
    this.inputType,
    this.enabled,
    this.suffixIconPressed,
    this.isSecureText,
    this.readOnly,
    this.maxLine,
    this.maxCharacter,
    this.minCharacter,
    this.onTap,
    this.style,
    this.obsucure,
    this.errorText,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      controller: controller,
      onTap: onTap,
      enabled: enabled,
      validator: validator,
      keyboardType: inputType,
      obscureText: isSecureText ?? false,
      maxLines: maxLine ?? 1,
      maxLength: maxCharacter,
      minLines: 1,
      style: style,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
        ),
        fillColor: enabled == null ? Colors.white : Colors.grey,
        focusColor: enabled == null ? Colors.white : Colors.grey,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        hintText: hintText,
        errorText: errorText,
        hintStyle: GoogleFonts.poppins(color: Colors.white70),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: suffixIconPressed,
                icon: suffixIcon ?? const FaIcon(FontAwesomeIcons.notEqual),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : IconButton(
                onPressed: prefixIconPressed,
                icon: prefixIcon ?? const FaIcon(FontAwesomeIcons.notEqual),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AdDetailsInput extends StatelessWidget {
  const AdDetailsInput({
    super.key,
    required this.title,
    required this.keyboard,
     this.onChanged,
    required this.obscure,
    required this.validator,
    required this.hint,
    this.prefixIcon,
    required this.textCapitalization,
    this.suffixIcon,
    required this.controller,
    this.maxLines,
  });

  final String title;
  final TextInputType keyboard;
  final bool obscure;
  final String? Function(String?)? validator;
  final String hint;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    double def = MediaQuery.of(context).textScaleFactor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Uber Move',
              fontSize: 12 / def,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLines: maxLines ?? 1,
          controller: controller,
          textCapitalization: textCapitalization,
          validator: validator,
          obscureText: obscure,
          onChanged: onChanged,
          keyboardType: keyboard,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red.withOpacity(0.6),
                )),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                width: 1.2,
                color: Colors.red,
              ),
            ),

            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 50,
              minWidth: 50,
            ),
            prefixIcon: prefixIcon,
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color:  Colors.black.withOpacity(0.5), width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.transparent, width:0),
                borderRadius: BorderRadius.circular(8)),
            fillColor: const Color.fromARGB(255,245,246,247),
            filled: true,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
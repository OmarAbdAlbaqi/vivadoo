import 'package:flutter/material.dart';
class AuthInput extends StatelessWidget {
  const AuthInput({
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
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    double def = MediaQuery.of(context).textScaleFactor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Uber Move',
              fontSize: 12 / def,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          validator: validator,
          obscureText: obscure,
          onChanged: onChanged,
          keyboardType: keyboard,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red.withOpacity(0.6),
                )),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                width: 1.2,
                color: Colors.red,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color:  Color.fromARGB(255, 39, 184, 141), width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 39, 184, 141).withOpacity(0.7), width: 0.5),
                borderRadius: BorderRadius.circular(12)),
            fillColor: const Color.fromARGB(255, 245,246,247),
            filled: true,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}


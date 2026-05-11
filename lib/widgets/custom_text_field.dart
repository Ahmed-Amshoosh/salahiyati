import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String hint;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(

            hintText: hint,

            prefixIcon: Icon(icon),

            suffixIcon: isPassword
                ? const Icon(Icons.visibility_outlined)
                : null,

            filled: true,
            fillColor: Colors.grey.shade100,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
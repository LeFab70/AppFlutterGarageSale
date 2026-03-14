import 'package:flutter/material.dart';

import '../colors/colors.app.dart';
TextField myTextField(
    String text,
    IconData icon,
    bool isPassWordType,
    TextEditingController controller,
    ) {
  return TextField(
    controller: controller,
    obscureText: isPassWordType,
    enableSuggestions: !isPassWordType,
    autocorrect: !isPassWordType,
    cursorColor: AppColors.primary,
    style: const TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.secondary),
      labelText: text,
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.secondary,
          width: 2,
        ),
      ),
    ),
  );
}




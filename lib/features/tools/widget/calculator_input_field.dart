import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class CalculatorInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  const CalculatorInputField({
    super.key,
    required this.label,
    required this.controller,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: GoogleFonts.robotoMono(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.robotoMono(
                color: AppTheme.secondaryText.withOpacity(0.6),
                fontSize: 16,
              ),
              prefixText: prefix,
              suffixText: suffix,
              prefixStyle: GoogleFonts.robotoMono(
                color: AppTheme.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              suffixStyle: GoogleFonts.robotoMono(
                color: AppTheme.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

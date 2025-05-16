import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove caracteres que não são digitos
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // garante que existe pelo menos 1 digito
    if (digitsOnly.isEmpty) {
      digitsOnly = '0';
    }
    
    // converte para double (centavos)
    double value = int.parse(digitsOnly) / 100;
    
    // formata para dinheiro/moeda
    String formatted = 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove caracteres que não são digitos
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limita para 8 digitos (DDMMYYYY)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }
    
    // Formata como DD/MM/YYYY
    String formatted = '';
    
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += digitsOnly[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
import 'package:flutter/material.dart';

// Classe para centralizar as configurações de tema do aplicativo
class AppTheme {
  // Construtor privado para impedir que a classe seja instanciada
  AppTheme._();

  // Cor primária da marca
  static const Color _primaryColor = Color(0xFF4AA66C);

  // Cor secundária da marca
  static const Color _secondaryColor = Color(0xFFFFC107);

  // Getter estático para o tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      // Ativa o Material Design 3, que oferece componentes mais modernos
      useMaterial3: true,

      // Define a paleta de cores do app a partir de uma cor "semente"
      // Flutter gera um esquema de cores harmonioso a partir de uma única cor
      // É mais moderno e completo que o fromSwatch
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        // Define o brilho geral do tema como claro
        brightness: Brightness.light,
      ),

      // Tema para todos os campos de texto (TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),

      // Tema para todos os widgets Switch (como em 'Editar Produto')
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor.withAlpha(600);
          }
          return Colors.grey.shade200;
        }),
      ),

      // Tema para todos os ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
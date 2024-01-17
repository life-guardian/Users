import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.blue),
    ),
  ),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.white,
    secondary: Colors.white,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    headerBackgroundColor: Colors.blue[200],
    dayOverlayColor: const MaterialStatePropertyAll(Colors.black),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white),
    ),
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.grey.shade700,
    headerBackgroundColor: Colors.grey.shade800,
    dayOverlayColor:
        const MaterialStatePropertyAll(Color.fromARGB(255, 200, 194, 194)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

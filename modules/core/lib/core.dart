library core;

import 'package:commons/commons.dart';
import 'package:core/routes/routes.dart';
import 'package:flutter/material.dart';

export 'routes/routes.dart';

class VoxxWeb extends StatelessWidget {
  const VoxxWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kLightBlue),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ),
      routerConfig: AppRouter.router,
    );
  }
}

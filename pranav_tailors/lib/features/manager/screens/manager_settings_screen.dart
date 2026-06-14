import 'package:flutter/material.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';

class ManagerSettingsScreen extends StatelessWidget {
  const ManagerSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Manager Settings', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Manager Settings', 
          style: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 16)),
      ),
    );
  }
}

import 'package:expence_manager/controllers/category/category_controller.dart';
import 'package:expence_manager/controllers/graph/graph_controller.dart';
import 'package:expence_manager/controllers/transaction/category_list_provider.dart';
import 'package:expence_manager/controllers/transaction/transaction_controller.dart';
import 'package:expence_manager/controllers/trash/trash_controller.dart';
import 'package:expence_manager/controllers/wellcome/login_controller.dart';
import 'package:expence_manager/demo/theam_data.dart';
import 'package:expence_manager/views/wellcome/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),

        ChangeNotifierProvider(create: (context) => CategoryController()),

        ChangeNotifierProvider(create: (context) => TransactionController()),

        ChangeNotifierProvider(create: (context) => CategoryListProvider()),

        ChangeNotifierProvider(create: (context) => GraphController()),

        ChangeNotifierProvider(create: (context) => TrashController()),
      ],

      child: MaterialApp(
        color: theme.primaryColor,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: TheamData.setAppTheam(),
      ),
    );
  }
}

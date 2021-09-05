import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modon_screens/screens/cart_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      title: 'Match',
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    );
  }
}

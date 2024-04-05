import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:looksbeyond/firebase_options.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';
import 'package:looksbeyond/provider/AuthProvider.dart';
import 'package:looksbeyond/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      "pk_test_51P07Xc2KIHEg32T5BJYwWDLLfVQDFWC9FxDAoAHbIWbHtEfZPQZlribf77K8LyYjidoHfCRWBMs7xsM14WM0OGvP00vdw67vEa";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationProvider>(
      create: (_) => AuthenticationProvider(),
      child: MaterialApp(
        title: 'Looks Beyond',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          scaffoldBackgroundColor: Color(0xfffafbfb),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xfffafbfb),
            titleTextStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: appRoutes,
        // home: const LoginPage(),
      ),
    );
  }
}

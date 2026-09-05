import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noBroker_user_dashboard/repositories/auth_repository.dart';
import 'package:noBroker_user_dashboard/repositories/user_repository.dart';
import 'package:noBroker_user_dashboard/services/auth_service.dart';
import 'package:noBroker_user_dashboard/services/user_service.dart';
import 'package:noBroker_user_dashboard/view_models/auth/auth_bloc.dart';
import 'package:noBroker_user_dashboard/view_models/user/user_bloc.dart';

import 'app/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository(AuthServices())),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(UserRepository(UserServices())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}

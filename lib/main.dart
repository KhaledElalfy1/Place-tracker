import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_tracker_app/features/home/presentation/view/home_view.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const LocationTrackerApp());
}

class LocationTrackerApp extends StatelessWidget {
  const LocationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => MapsCubit(),
        child: const HomeView(),
      ),
    );
  }
}

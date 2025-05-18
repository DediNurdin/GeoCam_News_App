import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/theme/theme_bloc.dart';
import 'app/theme/theme_event.dart';
import 'features/geocam/bloc/geocam_bloc.dart';
import 'features/geocam/bloc/geocam_event.dart';
import 'features/news/bloc/news_bloc.dart';
import 'features/news/bloc/news_event.dart';
import 'features/news/repository/news_repository.dart';
import 'services/camera_services.dart';
import 'services/location_services.dart';
import 'services/storage_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locationPermission = await Permission.location.request();
  if (!locationPermission.isGranted) {}

  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = StorageService(sharedPreferences);
  final locationService = LocationService();
  final cameraService = CameraService();
  final newsRepository = NewsRepository(storageService: storageService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(storageService)..add(LoadTheme()),
        ),
        BlocProvider(
          create: (context) => NewsBloc(newsRepository)..add(FetchNews()),
        ),
        BlocProvider(
          create: (context) => GeocamBloc(
            locationService: locationService,
            storageService: storageService,
            cameraService: cameraService,
          )..add(GetLocation()),
        ),
        BlocProvider(
          create: (context) => GeocamBloc(
            storageService: storageService,
            locationService: locationService,
            cameraService: cameraService,
          )..add(LoadGeocamData()),
        ),
      ],
      child: const App(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/app/app.dart';
import 'package:geo_cam_news/app/theme/theme_bloc.dart';
import 'package:geo_cam_news/app/theme/theme_event.dart';
import 'package:geo_cam_news/features/geocam/bloc/geocam_bloc.dart';
import 'package:geo_cam_news/features/geocam/bloc/geocam_event.dart';
import 'package:geo_cam_news/features/news/bloc/news_bloc.dart';
import 'package:geo_cam_news/features/news/bloc/news_event.dart';
import 'package:geo_cam_news/features/news/repository/news_repository.dart';
import 'package:geo_cam_news/services/camera_services.dart';
import 'package:geo_cam_news/services/location_services.dart';
import 'package:geo_cam_news/services/storage_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

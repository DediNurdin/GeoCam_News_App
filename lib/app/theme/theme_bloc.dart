import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/services/storage_services.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService storageService;

  ThemeBloc(this.storageService) : super(const ThemeInitial(false)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDarkMode = await storageService.getThemeMode() ?? false;
    emit(ThemeLoaded(isDarkMode));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    await storageService.saveThemeMode(!state.isDarkMode);
    emit(ThemeLoaded(!state.isDarkMode));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/services/camera_services.dart';
import 'package:geo_cam_news/services/location_services.dart';
import 'package:geo_cam_news/services/storage_services.dart';

import 'geocam_event.dart';
import 'geocam_state.dart';

class GeocamBloc extends Bloc<GeocamEvent, GeocamState> {
  final LocationService locationService;
  final StorageService storageService;
  final CameraService cameraService;

  GeocamBloc({
    required this.locationService,
    required this.storageService,
    required this.cameraService,
  }) : super(GeocamInitial()) {
    on<LoadGeocamData>(_onLoadSavedData);
    on<GetLocation>(_onGetCurrentLocation);
    on<TakePhoto>(_onCapturePhoto);
    on<SaveGeocamData>(_onSaveData);
    on<ResetData>(_onResetData);
  }

  Future<void> _onGetCurrentLocation(
    GetLocation event,
    Emitter<GeocamState> emit,
  ) async {
    emit(GeocamLoading());
    try {
      final position = await locationService.getCurrentLocation();

      if (state is GeocamLoaded) {
        final currentState = state as GeocamLoaded;
        emit(currentState.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      } else {
        emit(GeocamLoaded(
            latitude: position.latitude,
            longitude: position.longitude,
            imagePath: ''));
      }
    } catch (e) {
      emit(GeocamError('Gagal mendapatkan lokasi: ${e.toString()}'));
    }
  }

  Future<void> _onCapturePhoto(
    TakePhoto event,
    Emitter<GeocamState> emit,
  ) async {
    if (state is! GeocamLoaded) {
      emit(GeocamError('Harap dapatkan lokasi terlebih dahulu'));
      return;
    }

    final currentLoadedState = state as GeocamLoaded;
    emit(GeocamLoading());

    try {
      final photo = await cameraService.takePhoto();

      if (photo == null) {
        emit(currentLoadedState);
        return;
      }

      emit(currentLoadedState.copyWith(
        imagePath: photo.path,
      ));
    } catch (e) {
      emit(GeocamError('Gagal mengambil foto: ${e.toString()}'));
      await Future.delayed(const Duration(seconds: 2));
      emit(currentLoadedState);
    }
  }

  Future<void> _onSaveData(
    SaveGeocamData event,
    Emitter<GeocamState> emit,
  ) async {
    final currentState = state;

    if (currentState is! GeocamLoaded ||
        currentState.latitude == null ||
        currentState.longitude == null ||
        currentState.imagePath == null) {
      emit(GeocamError('Data tidak lengkap untuk disimpan'));
      return;
    }

    emit(GeocamSaving());

    try {
      final success = await storageService.saveGeocamData(
        latitude: currentState.latitude!,
        longitude: currentState.longitude!,
        imagePath: currentState.imagePath!,
      );

      if (success) {
        emit(GeocamLoaded(
          latitude: currentState.latitude,
          longitude: currentState.longitude,
          imagePath: currentState.imagePath,
          isSaved: true,
        ));

        await Future.delayed(const Duration(seconds: 2));
        emit(GeocamLoaded(
          latitude: currentState.latitude,
          longitude: currentState.longitude,
          imagePath: currentState.imagePath,
          isSaved: true,
        ));
      } else {
        emit(GeocamError('Gagal menyimpan data'));
        await Future.delayed(const Duration(seconds: 2));
        emit(currentState);
      }
    } catch (e) {
      emit(GeocamError('Error saat menyimpan: ${e.toString()}'));
      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }

  Future<void> _onLoadSavedData(
    LoadGeocamData event,
    Emitter<GeocamState> emit,
  ) async {
    emit(GeocamLoading());
    try {
      final savedData = storageService.loadGeocamData();
      if (savedData != null) {
        emit(GeocamLoaded(
          latitude: savedData['latitude'] as double,
          longitude: savedData['longitude'] as double,
          imagePath: savedData['imagePath'] as String,
          savedAt: DateTime.parse(savedData['savedAt'] as String),
        ));
      } else {
        emit(GeocamInitial());
      }
    } catch (e) {
      emit(GeocamError('Gagal memuat data: ${e.toString()}'));
    }
  }

  Future<void> _onResetData(
    ResetData event,
    Emitter<GeocamState> emit,
  ) async {
    emit(GeocamLoading());
    try {
      await storageService.clearGeocamData();
      emit(GeocamInitial());
    } catch (e) {
      emit(GeocamError('Gagal mereset data: ${e.toString()}'));
    }
  }
}

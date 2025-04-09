abstract class GeocamState {}

class GeocamInitial extends GeocamState {}

class GeocamLoading extends GeocamState {}

class GeocamSaving extends GeocamState {}

class GeocamLoaded extends GeocamState {
  final double? latitude;
  final double? longitude;
  final String? imagePath;
  final bool isSaved;
  final DateTime? savedAt;

  GeocamLoaded({
    this.latitude,
    this.longitude,
    this.imagePath,
    this.isSaved = false,
    this.savedAt,
  });

  GeocamLoaded copyWith({
    double? latitude,
    double? longitude,
    String? imagePath,
    bool? isSaved,
  }) {
    return GeocamLoaded(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      isSaved: isSaved ?? this.isSaved,
      savedAt: savedAt ?? savedAt,
    );
  }
}

class GeocamError extends GeocamState {
  final String message;

  GeocamError(this.message);
}

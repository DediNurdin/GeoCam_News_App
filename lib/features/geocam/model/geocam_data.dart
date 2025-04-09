import 'package:equatable/equatable.dart';

class GeocamData extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? imagePath;
  final DateTime? timestamp;

  GeocamData({
    this.latitude,
    this.longitude,
    this.imagePath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  GeocamData copyWith({
    double? latitude,
    double? longitude,
    String? imagePath,
    DateTime? timestamp,
  }) {
    return GeocamData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory GeocamData.fromJson(String jsonString) {
    try {
      final json = jsonString as Map<String, dynamic>;
      return GeocamData(
        latitude: json['latitude'] as double?,
        longitude: json['longitude'] as double?,
        imagePath: json['imagePath'] as String?,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : null,
      );
    } catch (e) {
      throw FormatException('Failed to parse GeocamData from JSON: $e');
    }
  }

  @override
  List<Object?> get props => [latitude, longitude, imagePath, timestamp];

  bool get hasLocation => latitude != null && longitude != null;
  bool get hasImage => imagePath != null;
  bool get isComplete => hasLocation && hasImage;

  String get locationString {
    if (latitude == null || longitude == null) {
      return 'No location data';
    }
    return 'Lat: ${latitude!.toStringAsFixed(4)}, Lng: ${longitude!.toStringAsFixed(4)}';
  }

  String get formattedDate {
    return timestamp?.toLocal().toString() ?? 'No timestamp';
  }
}

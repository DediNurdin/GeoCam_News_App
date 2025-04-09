import 'package:equatable/equatable.dart';

abstract class GeocamEvent extends Equatable {
  const GeocamEvent();

  @override
  List<Object> get props => [];
}

class LoadGeocamData extends GeocamEvent {}

class GetLocation extends GeocamEvent {}

class TakePhoto extends GeocamEvent {}

class SaveGeocamData extends GeocamEvent {
  final double? latitude;
  final double? longitude;
  final String? imagePath;

  const SaveGeocamData({this.latitude, this.longitude, this.imagePath});
}

class ResetData extends GeocamEvent {}

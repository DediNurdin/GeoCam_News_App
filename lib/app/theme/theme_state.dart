import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(super.isDarkMode);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.isDarkMode);
}

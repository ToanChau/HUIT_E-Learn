import 'package:equatable/equatable.dart';

class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThemeInitialEvent extends ThemeEvent {}

class ThemeToggleEvent extends ThemeEvent {}

class ThemeSetEvent extends ThemeEvent {
  final bool isDarkMode;
  ThemeSetEvent({required this.isDarkMode});
  @override
  List<Object?> get props => [isDarkMode];
}

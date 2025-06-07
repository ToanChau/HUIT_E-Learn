import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/theme/theme_event.dart';
import 'package:huit_elearn/viewModels/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(isDarkMode: false)) {
    on<ThemeInitialEvent>(_onInitialEvent);
    on<ThemeToggleEvent>(_onToggleEvent);
    on<ThemeSetEvent>(_onSetEvent);

    add(ThemeInitialEvent());
  }

  Future<void> _onInitialEvent(
    ThemeInitialEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  Future<void> _onToggleEvent(
    ThemeToggleEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newstate = !state.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newstate);
    emit(ThemeState(isDarkMode: newstate));
  }

  Future<void> _onSetEvent(
    ThemeSetEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', event.isDarkMode);
    emit(ThemeState(isDarkMode: event.isDarkMode));
  }
}

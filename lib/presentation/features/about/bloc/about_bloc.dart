import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutInitial()) {
    on<LoadAppInfo>(_onLoadAppInfo);
  }

  Future<void> _onLoadAppInfo(
      LoadAppInfo event, Emitter<AboutState> emit) async {
    emit(AboutLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate fetch
      // Replace with actual data fetching logic (e.g., from package_info_plus)
      emit(AboutInfoLoaded(
        appVersion: "1.0.0",
        developerInfo: "Theoretical Minds Technologies",
        contactEmail: "support@caribconnect.app",
      ));
    } catch (e) {
      emit(AboutError(
          errorMessage: "Failed to load app info: ${e.toString()}"));
    }
  }
}
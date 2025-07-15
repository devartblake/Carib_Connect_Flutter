part of 'about_bloc.dart';

@immutable
abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutInfoLoaded extends AboutState {
  final String appVersion;
  final String developerInfo;
  final String contactEmail;

  AboutInfoLoaded({
    required this.appVersion,
    required this.developerInfo,
    required this.contactEmail,
  });
}

class AboutError extends AboutState {
  final String errorMessage;
  AboutError({required this.errorMessage});
}
part of 'home_bloc.dart'; // Links to home_bloc.dart

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {} // Initial state before anything is loaded

class HomeLoading extends HomeState {} // State when data is being fetched

// State when data is successfully loaded
class HomeLoaded extends HomeState {
  // final YourHomeDataModel homeData; // Replace with your actual data model
  final String welcomeMessage; // Example data
  final List<String> featuredItems; // Example data

  HomeLoaded({
    // required this.homeData,
    required this.welcomeMessage,
    required this.featuredItems,
  });

// For Equatable if you want value comparison for states
// @override
// List<Object> get props => [homeData];
}

// State when an error occurs
class HomeError extends HomeState {
  final String errorMessage;

  HomeError({required this.errorMessage});

// @override
// List<Object> get props => [errorMessage];
}
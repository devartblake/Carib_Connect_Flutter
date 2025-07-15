part of 'home_bloc.dart'; // Links to home_bloc.dart


@immutable
abstract class HomeEvent {}

// Example event: Initial event to load home data
class LoadHomeData extends HomeEvent {}

// Example event: User refreshes the home screen
class RefreshHomeData extends HomeEvent {}

// Add more specific events as your home screen functionality grows
// e.g., class UserTappedFeaturedItem extends HomeEvent { final String itemId; UserTappedFeaturedItem(this.itemId); }
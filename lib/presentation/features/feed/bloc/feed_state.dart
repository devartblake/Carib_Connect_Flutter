part of 'feed_bloc.dart';

@immutable
abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  // final List<FeedItemModel> items; // Replace with your FeedItemModel
  // final bool hasReachedMax; // For pagination
  final List<String> feedPosts; // Example data

  FeedLoaded({
    // required this.items,
    // this.hasReachedMax = false,
    required this.feedPosts,
  });
}

class FeedError extends FeedState {
  final String errorMessage;
  FeedError({required this.errorMessage});
}
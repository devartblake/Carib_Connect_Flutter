part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent {}

class LoadFeedItems extends FeedEvent {}

class RefreshFeedItems extends FeedEvent {}

class LoadMoreFeedItems extends FeedEvent {} // For pagination
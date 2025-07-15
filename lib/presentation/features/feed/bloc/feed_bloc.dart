import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<LoadFeedItems>(_onLoadFeedItems);
    on<RefreshFeedItems>(_onRefreshFeedItems);
  }

  Future<void> _onLoadFeedItems(
      LoadFeedItems event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate fetch
      // Replace with actual data fetching logic
      emit(FeedLoaded(
          feedPosts:
          List.generate(10, (index) => "Feed Post Title ${index + 1}")));
    } catch (e) {
      emit(FeedError(errorMessage: "Failed to load feed: ${e.toString()}"));
    }
  }

  Future<void> _onRefreshFeedItems(
      RefreshFeedItems event, Emitter<FeedState> emit) async {
    // Similar to initial load, but could preserve old data while refreshing
    await _onLoadFeedItems(LoadFeedItems(), emit);
  }
}
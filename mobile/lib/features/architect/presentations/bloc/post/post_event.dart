part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

final class AllPosts extends PostEvent {
  const AllPosts({
    this.search,
    this.tags,
  });

  final String? search;
  final List<String>? tags;

  @override
  List<Object?> get props => [search, tags];
}

final class ViewsPosts extends PostEvent {
  const ViewsPosts({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];
}
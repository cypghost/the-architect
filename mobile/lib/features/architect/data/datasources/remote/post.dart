import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../../../../core/errors/exception.dart';
import '../../models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> allPosts(
      String? search, List<String>? tags, String token);
  Future<List<PostModel>> viewsPost(String id, String token);
  Future<PostModel> createPost({
    required String image,
    required String title,
    String? content,
    required List<String> tags,
    required String userId,
    required String token,
  });

  Future<PostModel> editPost({
    required String image,
    required String title,
    String? content,
    required List<String> tags,
    required String userId,
    required String token,
  });

  Future<PostModel> deletePost(String id, String token);
  Future<PostModel> likePost(String id, String token);
  Future<PostModel> clonePost(String id, String token);
  Future<PostModel> unLikePost(String id, String token);
  Future<PostModel> viewPost(String id, String token);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  const PostRemoteDataSourceImpl({required this.client});

  final Client client;

  @override
  Future<List<PostModel>> allPosts(
      String? search, List<String>? tags, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> postsJson = json.decode(response.body);
      final List<PostModel> posts = [];
      for (final post in postsJson) {
        posts.add(PostModel.fromJson(post));
      }
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> viewsPost(String id, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/users/$id/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> postsJson = json.decode(response.body);
      final List<PostModel> posts = [];
      for (final post in postsJson) {
        posts.add(PostModel.fromJson(post));
      }
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> clonePost(String id, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/$id/clone'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> likePost(String id, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/$id/like'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> unLikePost(String id, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/$id/unlike'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> createPost(
      {required String image,
      required String title,
      String? content,
      required List<String> tags,
      required String userId,
      required String token}) async {
    final response = await client.post(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(
        {
          'image': image,
          'title': title,
          'content': content ?? '',
          'userId': userId,
          'tags': tags,
        },
      ),
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> deletePost(String id, String token) async {
    final response = await client.delete(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> editPost(
      {required String image,
      required String title,
      String? content,
      required List<String> tags,
      required String userId,
      required String token}) async {
    final response = await client.put(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/{id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(
        {
          'image': image,
          'title': title,
          'content': content ?? '',
          'userId': userId,
          'tags': tags,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> viewPost(String id, String token) async {
    final response = await client.get(
      Uri.parse('https://the-architect.onrender.com/api/v1/posts/$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      final PostModel posts = PostModel.fromJson(postsJson);
      return posts;
    } else {
      throw ServerException();
    }
  }
}

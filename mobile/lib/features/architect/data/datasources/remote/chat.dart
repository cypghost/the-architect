import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../../../../core/errors/exception.dart';
import '../../models/chat.dart';
import '../../models/message.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> create({
    required Map<String, dynamic> payload,
    required String userId,
    required String model,
    required String token,
  });

  Future<ChatModel> viewChat(String id, String token);
  Future<List<ChatModel>> viewChats(String userId, String token);
  Future<ChatModel> delete(String id, String token);

  Future<MessageModel> message({
    required Map<String, dynamic> payload,
    required String chatId,
    required String model,
    required String token,
    required String userId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({
    required this.client,
  });

  final Client client;

  @override
  Future<ChatModel> create({
    required Map<String, dynamic> payload,
    required String userId,
    required String model,
    required String token,
  }) async {
    final response = await client.post(
        Uri.parse("https://the-architect.onrender.com/api/v1/chats/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payload': payload,
          'user_id': userId,
          'model': model,
        }));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ChatModel.fromJson(jsonData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> viewChat(String id, String token) async {
    final response = await client.get(
      Uri.parse("https://the-architect.onrender.com/api/v1/chats/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ChatModel.fromJson(jsonData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> viewChats(String userId, String token) async {
    final response = await client.get(
      Uri.parse(
          "https://the-architect.onrender.com/api/v1/users/$userId/chats"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> chatsJson = json.decode(response.body);
      final List<ChatModel> chats = [];

      for (final chat in chatsJson) {
        chats.add(ChatModel.fromJson(chat));
      }
      return chats;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MessageModel> message({
    required Map<String, dynamic> payload,
    required String chatId,
    required String model,
    required String token,
    required String userId,
  }) async {
    final response = await client.post(
        Uri.parse(
            "https://the-architect.onrender.com/api/v1/chats/$chatId/messages"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payload': payload,
          'user_id': userId,
          'model': model,
        }));
    if (response.statusCode == 200) {
      print('${response.body} ${response.statusCode}');
      final jsonData = json.decode(response.body);
      return MessageModel.fromJson(jsonData);
    } else {
      print('${response.body} ${response.statusCode}');
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> delete(String id, String token) async {
    final response = await client.delete(
      Uri.parse("https://the-architect.onrender.com/api/v1/chats/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ChatModel.fromJson(jsonData);
    } else {
      throw ServerException();
    }
  }
}

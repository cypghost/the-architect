import 'dart:io';

import 'package:architect/features/architect/presentations/page/chat.dart';
import 'package:architect/features/architect/presentations/page/post_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../domains/entities/user.dart';

class ChatMessage extends StatelessWidget {
  final Message content;
  final bool isSentByMe;
  final VoidCallback onDeleted;
  final List<Message> messages;
  final User user;

  const ChatMessage({
    super.key,
    required this.onDeleted,
    required this.content,
    required this.user,
    required this.isSentByMe,
    required this.messages,
  });

  void _showImageInFull(BuildContext context, String image) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (_) => Dialog(
        child: Image.network(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  String capitalizeAll(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.split(' ').map((e) => capitalize(e)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft:
          isSentByMe ? const Radius.circular(20.0) : const Radius.circular(0.0),
      topRight:
          isSentByMe ? const Radius.circular(0.0) : const Radius.circular(20.0),
      bottomLeft: const Radius.circular(20.0),
      bottomRight: const Radius.circular(20.0),
    );

    final alignment =
        isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    ColorFilter colorFilter = ColorFilter.mode(
      Colors.black.withOpacity(0.5),
      BlendMode.darken,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          if (isSentByMe && content.imageUser.isEmpty && !content.isPicked)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: borderRadius,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                content.prompt,
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          if (isSentByMe &&
              content.imageUser.isNotEmpty &&
              content.isPicked &&
              content.prompt.isEmpty)
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: ColorFiltered(
                          colorFilter: colorFilter,
                          child: Image.file(
                            File(content.imageUser),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          iconSize: 50,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          icon: const Icon(Icons.cancel),
                          onPressed: onDeleted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (isSentByMe &&
              content.imageUser.isNotEmpty &&
              content.isPicked &&
              content.prompt.isNotEmpty)
            ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: borderRadius,
                ),
                child: Column(
                  children: [
                    Image.file(
                      File(content.imageUser),
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        capitalize(content.prompt),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          if (isSentByMe &&
              content.imageUser.isNotEmpty &&
              !content.isPicked &&
              content.chat.isEmpty &&
              content.prompt.isNotEmpty)
            ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: borderRadius,
                ),
                child: Column(
                  children: [
                    Image.network(
                      content.imageUser,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        capitalize(content.prompt),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          if (isSentByMe &&
              content.imageUser.isNotEmpty &&
              !content.isPicked &&
              content.chat.isNotEmpty &&
              content.prompt.isNotEmpty)
            ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: borderRadius,
                ),
                child: Column(
                  children: [
                    Image.file(
                      File(content.imageUser),
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        capitalize(content.prompt),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          if (!isSentByMe &&
              (content.imageAI.isNotEmpty ||
                  (content.threeD.containsKey('fetch_result') &&
                      content.threeD['fetch_result'].isNotEmpty)))
            GestureDetector(
              onDoubleTap: () => {
                _showImageInFull(
                    context,
                    content.imageAI.isNotEmpty
                        ? content.imageAI
                        : content.threeD['fetch_result'])
              },
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Stack(
                  children: [
                    Image.network(
                      content.imageAI.isNotEmpty
                          ? content.imageAI
                          : content.threeD['fetch_result'],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 10,
                      bottom: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chat(
                                      
                                      user: user,
                                      messageX: messages,
                                      replay: content,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.replay_outlined,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostPage(
                                        user: user,
                                        imageUrl: content.model == 'text_to_3D'
                                            ? content.threeD['fetch_result']
                                            : content.imageAI),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.share_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!isSentByMe && content.chat.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: borderRadius,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                content.chat,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          if (!isSentByMe &&
              content.analysis.containsKey('title') &&
              content.analysis['title'].isNotEmpty &&
              content.analysis.containsKey('detail') &&
              content.analysis['detail'].isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: borderRadius,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      capitalizeAll(content.analysis['title']),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content.analysis['detail'],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          if (messages[0] == content && content.prompt.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SpinKitThreeBounce(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

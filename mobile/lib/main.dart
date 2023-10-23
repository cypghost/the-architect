import 'package:architect/features/architect/presentations/bloc/chat/chat_bloc.dart';
import 'package:architect/features/architect/presentations/bloc/post/post_bloc.dart';
import 'package:architect/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/architect/presentations/page/login.dart';
import 'injection_container.dart' as di;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PostBloc>()
            ..add(
              const AllPosts(tags: [], search: ''),
            ),
        ),
        BlocProvider(
          create: (context) => sl<ChatBloc>()
            ..add(
              const ChatViewsEvent(
                userId: '35a70fdf-7d7d-4f2f-a97c-5e1eeb5bc33a',
              ),
            ),
        )
      ],
      child: MaterialApp(
        title: 'Architect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Login(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/notes/add_notes.dart';
import 'Screens/notes/user_notes_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/tabs_screen.dart';
import 'Screens/tasks/add_task_screen.dart';
import 'Screens/tasks/user_task_screen.dart';
import 'Screens/user_add_screen.dart';
import 'Screens/user_detail_screen.dart';
import 'Widgets/app_theme.dart';
import 'helper/scroll_behaviour.dart';
import 'providers/auth.dart';
import 'providers/notes_provider.dart';
import 'providers/task_provider.dart';
import 'providers/user_provider.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
     
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({Key? key, }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final int sdkVersion;

  launchApp() async{
     final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final androidSdkVersion =
      deviceInfo is AndroidDeviceInfo ? deviceInfo.version.sdkInt : 0;
      setState(() {
        sdkVersion = androidSdkVersion;
      });
  }


  @override
  void initState() {
    launchApp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Task Manager - Notes App',
      debugShowCheckedModeBanner: false,      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LandingPage(androidSdkVersion: sdkVersion),
    );
  }
}

class LandingPage extends StatefulWidget {
  // const LandingPage({super.key});
  LandingPage({Key? key, required this.androidSdkVersion}) : super(key: key);
  final int androidSdkVersion;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TasksProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: NotesProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollBehavior(
              androidSdkVersion: widget.androidSdkVersion,
            ),
            theme: Provider.of<UserProvider>(context).isDark
                ? DarkTheme.darkThemeData
                : LightTheme.lightThemeData,
            home: auth.isAuth
                ? const Tabs()
                : FutureBuilder(
                    future: auth.tryLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Container(
                                color: Colors.white,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SplashScreen(),
                  ),
            routes: {
              AddTask.routeName: (ctx) => const AddTask(),
              UserTaskScreen.routeName: (ctx) => const UserTaskScreen(),
              UserAddScreen.routeName: (ctx) => const UserAddScreen(),
              UserDetailScreen.routeName: (ctx) => const UserDetailScreen(),
              Tabs.routeName: (ctx) => const Tabs(),
              UserNoteScreen.routeName: (ctx) => const UserNoteScreen(),
              AddNote.routeName: (ctx) => const AddNote(),
            },
          );
        },
      ),
    );
  }
}



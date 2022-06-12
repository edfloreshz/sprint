import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splendid/gui/widgets/global/sidebar.dart';
import 'package:splendid/providers/navigation.dart';
import 'package:splendid/utils/constants.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  if (isMobile) {
    FlutterNativeSplash.remove();
  }
  runApp(const ProviderScope(child: MyApp()));
}

void initialization(BuildContext context) async {
  //Load dependencies and more
  dotenv.load();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sprint',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      home: const Home(title: 'Splendid'),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    ref.read(navigationProvider);
  }

  var isSidebarVisible = true;

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(navigationProvider);
    final pages = ref.watch(pagesProvider);
    return Scaffold(
      body: Row(
        children: [
          Visibility(
            visible: isSidebarVisible,
            child: Column(
              children: [Sidebar(selectedItem: selectedItem, ref: ref)],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              isSidebarVisible = !isSidebarVisible;
                            }),
                            child: const Icon(Icons.vertical_split),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            selectedItem.name.characters.first.toUpperCase() +
                                selectedItem.name.substring(1),
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: pages[selectedItem.index],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
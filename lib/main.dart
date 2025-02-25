import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;
  String message = "Welcome!";
  Color backgroundColor = Colors.white;

  void increment(int newValue) {
    value = newValue;
    if (value <= 12) {
      message = "You're a child!";
      backgroundColor = Colors.lightBlue;
    } else if (value <= 19) {
      message = "Teenager time!";
      backgroundColor = Colors.lightGreen;
    } else if (value <= 30) {
      message = "You're a young adult!";
      backgroundColor = Colors.yellow.shade200;
    } else if (value <= 50) {
      message = "You're an adult now!";
      backgroundColor = Colors.orange;
    } else {
      message = "Golden years!";
      backgroundColor = Colors.grey.shade300;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: context.watch<Counter>().backgroundColor,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'I am ${context.watch<Counter>().value} years old',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              context.watch<Counter>().message,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Slider(
              value: context.watch<Counter>().value.toDouble(),
              min: 0,
              max: 99,
              divisions: 99,
              label: context.watch<Counter>().value.toString(),
              onChanged: (double value) {
                context.read<Counter>().increment(value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}

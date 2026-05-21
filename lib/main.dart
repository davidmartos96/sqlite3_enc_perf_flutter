import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_perf_flutter/perf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            FilledButton(
              onPressed: () async {
                final dbDir = await getDbDir();
                await dbDir.create(recursive: true);
                final dbPath = join(dbDir.path, "test.db");

                await runPerf(dbPath);
              },
              child: Text("Start random lookup"),
            ),

            FilledButton(
              onPressed: () async {
                final dbDir = await getDbDir();
                if (!dbDir.existsSync()) {
                  print("DB dir doesn't exist, skipping delete");
                  return;
                }

                await dbDir.delete(recursive: true);
                print("Deleted!");
              },
              child: Text("Delete db"),
            ),
          ],
        ),
      ),
    );
  }

  Future<Directory> getDbDir() async {
    final supportDir = await getApplicationSupportDirectory();
    return Directory(join(supportDir.path, "test"));
  }
}

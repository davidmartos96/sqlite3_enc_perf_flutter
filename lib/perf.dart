import 'dart:io';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:sqlite3/sqlite3.dart';

const _uuid = Uuid();

const kNumItems = 100;
const kTotalItems = 100000;
const kDbKey = "asdfasdf";
final r = Random(10000);

const kTargetCol = "some_col"; // String column to lookup
const kTargetTable = "items"; // Table name

Future<void> runPerf(String databasePath) async {
  setupSqliteOpenOverrides();

  await initializeDb(databasePath);

  final db = sqlite3.open(databasePath);

  db.execute("PRAGMA cipher = 'sqlcipher'");
  db.execute("PRAGMA legacy = 4");
  
  db.execute("PRAGMA key = '$kDbKey'");

  await testPerf(db);
}

Future<void> initializeDb(String databasePath) async {
  if (File(databasePath).existsSync()) {
    print("DB already exists, skipping initialization");
    return;
  }

  final db = sqlite3.open(databasePath);
  
  db.execute("PRAGMA cipher = 'sqlcipher'");
  db.execute("PRAGMA legacy = 4");
  
  db.execute("PRAGMA key = '$kDbKey'");

  db.execute('''
    CREATE TABLE IF NOT EXISTS $kTargetTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      $kTargetCol TEXT
    )
  ''');

  final stmt = db.prepare("INSERT INTO $kTargetTable ($kTargetCol) VALUES (?)");
  db.execute("BEGIN");
  for (var i = 0; i < kTotalItems; i++) {
    stmt.execute([_uuid.v4()]);
  }
  db.execute("COMMIT");

  db.close();
}

Future<void> testPerf(Database db) async {
  final items = await getItemsToSearch(db);

  print("Starting search. Num searchs = $kNumItems");
  final sw = Stopwatch();
  sw.start();
  for (final i in items) {
    db.select("SELECT * FROM $kTargetTable WHERE $kTargetCol = ?", [i]);
  }

  sw.stop();
  print("Took ${sw.elapsedMilliseconds} ms");
  print("Per item ${sw.elapsedMilliseconds / kNumItems} ms");
}

Future<List<String>> getItemsToSearch(Database db) async {
  final items = db.select("SELECT $kTargetCol FROM $kTargetTable");

  final all = items.toList().map((i) => i.values.first as String).toList();

  all.shuffle(r);
  return all.take(kNumItems).toList();
}

void setupSqliteOpenOverrides() {
  // if (Platform.isMacOS) {
  //   sqlite_open.open.overrideFor(
  //     sqlite_open.OperatingSystem.macOS,
  //     () => DynamicLibrary.open("./sqlite_libs/libsqlite3.dylib"),
  //   );
  // }

  // if (Platform.isLinux) {
  //   sqlite_open.open.overrideFor(
  //     sqlite_open.OperatingSystem.linux,
  //     () => DynamicLibrary.open("./sqlite_libs/libsqlite3.so"),
  //   );
  // }
}

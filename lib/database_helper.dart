import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'emergency_contacts.db');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE emergency_contacts(
        id INTEGER PRIMARY KEY,
        name TEXT,
        phoneNumber TEXT
      )
    ''').catchError((error) {
      print("Error creating table: $error");
    });
  }

  Future<int> insertContact(EmergencyContact contact) async {
    final dbClient = await db;
    return await dbClient.insert('emergency_contacts', contact.toMap());
  }

  Future<List<EmergencyContact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('emergency_contacts');
    return List.generate(maps.length, (i) {
      return EmergencyContact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
      );
    });
  }

  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient.delete('emergency_contacts', where: 'id = ?', whereArgs: [id]);
  }
}

class EmergencyContact {
  int? id;
  String? name;
  String? phoneNumber;

  EmergencyContact({this.id, this.name, this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phoneNumber': phoneNumber};
  }
}

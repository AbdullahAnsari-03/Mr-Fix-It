import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mr_fixit.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Users Table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        // Bookings Table
        await db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userEmail TEXT,
            serviceName TEXT,
            date TEXT,
            time TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  // 🔹 Insert a new user
  Future<int> insertUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🔹 Get user by email and password (for login)
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

// 🔹 Insert a new booking
  Future<int> insertBooking(String userEmail, String serviceName, String date, String time) async {
    final db = await database;
    int result = await db.insert(
      'bookings',
      {
        'userEmail': userEmail,
        'serviceName': serviceName,
        'date': date,
        'time': time,
        'status': 'active',
      },
    );

    // 📌 Debugging: Print all bookings after inserting
    List<Map<String, dynamic>> allBookings = await db.query('bookings');
    print("📌 All Bookings in DB: $allBookings");

    return result;
  }


  // 🔹 Get active bookings for a user
  Future<List<Map<String, dynamic>>> getActiveBookings(String userEmail) async {
    final db = await database;
    List<Map<String, dynamic>> activeBookings = await db.query(
      'bookings',
      where: 'userEmail = ? AND status = ?',
      whereArgs: [userEmail, 'active'],
    );
    print("✅ Active Bookings for $userEmail: $activeBookings");
    return activeBookings;
  }

  // 🔹 Move expired bookings to previous
  Future<void> updateBookingStatus() async {
    final db = await database;
    String currentDate = DateTime.now().toIso8601String().split("T")[0];

    await db.update(
      'bookings',
      {'status': 'previous'},
      where: 'date < ? AND status = ?',
      whereArgs: [currentDate, 'active'],
    );
  }

  // 🔹 Get previous bookings for a user
  Future<List<Map<String, dynamic>>> getPreviousBookings(String userEmail) async {
    final db = await database;
    List<Map<String, dynamic>> previousBookings = await db.query(
      'bookings',
      where: 'userEmail = ? AND status = ?',
      whereArgs: [userEmail, 'previous'],
    );
    print("🔄 Previous Bookings for $userEmail: $previousBookings");
    return previousBookings;
  }
}

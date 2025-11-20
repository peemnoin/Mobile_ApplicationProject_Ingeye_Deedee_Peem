import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Score {
  final int? id;
  final String player;
  final int score;
  final DateTime createdAt;

  Score({
    this.id,
    required this.player,
    required this.score,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player': player,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'] as int?,
      player: map['player'] as String,
      score: map['score'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

class ScoreDatabase {
  ScoreDatabase._privateConstructor();
  static final ScoreDatabase instance = ScoreDatabase._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scores_24game.db');
    return _database!;
  }

  // INIT DATABASE
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Normal scores
        await db.execute('''
          CREATE TABLE scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player TEXT NOT NULL,
            score INTEGER NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');

        // Challenge Best Score (store only 1 record)
        await db.execute('''
          CREATE TABLE challenge_best (
            id INTEGER PRIMARY KEY,
            best INTEGER NOT NULL
          )
        ''');

        // Insert default best score = 0
        await db.insert("challenge_best", {"id": 1, "best": 0});
      },
    );
  }

  // NORMAL SCORE FUNCTIONS
  Future<int> getTotalScore() async {
    final db = await instance.database;
    final result = await db.rawQuery("SELECT SUM(score) as total FROM scores");
    return (result.first["total"] as int?) ?? 0;
  }

  Future<int> insertScore(Score score) async {
    final db = await database;
    return await db.insert('scores', score.toMap());
  }

  Future<List<Score>> getAllScores() async {
    final db = await database;
    final maps = await db.query(
      'scores',
      orderBy: 'score DESC, createdAt DESC',
    );
    return maps.map((m) => Score.fromMap(m)).toList();
  }

  Future<void> clearScores() async {
    final db = await database;
    await db.delete('scores');
  }

  // CHALLENGE MODE BEST SCORE
  Future<int> getChallengeBestScore() async {
  final db = await database;
  final result = await db.query("challenge_best", where: "id = 1", limit: 1);

  if (result.isEmpty) return 0;
  return result.first["best"] as int;
}


  Future<void> saveChallengeBestScore(int newScore) async {
    final db = await database;
    await db.update("challenge_best", {"best": newScore}, where: "id = 1");
  }
}

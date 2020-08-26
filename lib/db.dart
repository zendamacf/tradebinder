import 'package:tradebinder/config.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tradebinder/model/card.dart';

class DB {
  DB._();
  static final DB db = DB._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), Config.DBFILE);
    return await openDatabase(
      path,
      version: Config.SCHEMAVERSION,
      onCreate: (Database db, int version) async => await createTables(db),
    );
  }

  void createTables(Database db) async {
    print('Inserting database tables.');
    await db.execute(
      'CREATE TABLE card ('
      'id INTEGER PRIMARY KEY,'
      'collectornumber TEXT,'
      'name TEXT,'
      'rarity TEXT,'
      'type TEXT,'
      'power TEXT,'
      'toughness TEXT,'
      'oracletext TEXT,'
      'flavortext TEXT,'
      'url TEXT,'
      'imageurl TEXT,'
      'setname TEXT'
      ')'
    );
    await db.execute(
      'CREATE TABLE trade ('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'occurred TEXT'
      ')'
    );
    await db.execute(
      'CREATE TABLE trade_card ('
      'cardid INTEGER REFERENCES card(id),'
      'tradeid INTEGER REFERENCES trade(id),'
      'foil BOOLEAN,'
      'quantity INTEGER,'
      'price TEXT,'
      'PRIMARY KEY (cardid, tradeid)'
      ')'
    );
  }

  void addCards(List<MagicCard> cards) async {
    final db = await database;
    final batch = db.batch();
    cards.forEach((card) async {
      batch.insert('card', card.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    await batch.commit();
  }

  Future<List<MagicCard>> searchCards(String searchQuery) async {
    final db = await database;
    // Find all cards with the search query inside the name
    final res = await db.query(
      'card',
      where: 'INSTR(TRIM(LOWER(name)), TRIM(LOWER(?))) > 0',
      whereArgs: [searchQuery],
      orderBy: 'name'
    );
    // Convert into a list of cards
    final cardlist = res.isNotEmpty ? res.map<MagicCard>((e) => MagicCard.fromMap(e)).toList() : [];
    return cardlist;

  }
}

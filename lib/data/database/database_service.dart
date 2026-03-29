import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _dbName = 'tasko_mobile.db';
  static const _dbVersion = 3;

  static const vendedoresTable = 'vendedores';
  static const syncQueueTable = 'sync_queue';

  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createVendedoresTable(db);
    await _createSyncQueueTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS dogs');
      await _createVendedoresTable(db);
      await _createSyncQueueTable(db);
    }

    if (oldVersion < 3) {
      await _upgradeToV3(db);
    }
  }

  Future<void> _upgradeToV3(Database db) async {
    await _addColumnIfNotExists(db, vendedoresTable, 'local_uuid', 'TEXT');

    await _addColumnIfNotExists(
      db,
      syncQueueTable,
      'client_operation_id',
      'TEXT',
    );
    await _addColumnIfNotExists(db, syncQueueTable, 'next_retry_at', 'TEXT');
    await _addColumnIfNotExists(db, syncQueueTable, 'last_attempt_at', 'TEXT');
    await _addColumnIfNotExists(db, syncQueueTable, 'idempotency_key', 'TEXT');

    final nowIso = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      "UPDATE $syncQueueTable SET client_operation_id = COALESCE(client_operation_id, entity_type || ':' || operation || ':' || entity_id || ':' || id)",
    );
    await db.execute(
      "UPDATE $syncQueueTable SET next_retry_at = COALESCE(next_retry_at, created_at, '$nowIso')",
    );
    await db.execute(
      'UPDATE $syncQueueTable SET idempotency_key = COALESCE(idempotency_key, client_operation_id)',
    );

    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_sync_queue_client_operation ON $syncQueueTable (client_operation_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_queue_due ON $syncQueueTable (status, next_retry_at, created_at)',
    );
  }

  Future<void> _addColumnIfNotExists(
    Database db,
    String table,
    String column,
    String type,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    }
  }

  Future<void> _createVendedoresTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $vendedoresTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        codigo_vendedor TEXT NOT NULL,
        nome_vendedor TEXT NOT NULL,
        numero_cpf TEXT NOT NULL,
        email TEXT NOT NULL,
        numero_telefone TEXT NOT NULL,
        valor_meta_mensal REAL,
        percentual_comissao REAL NOT NULL,
        ultimo_sincronismo TEXT,
        codigo_dispositivo TEXT,
        supervisor_id INTEGER,
        supervisor_nome TEXT,
        territorio_id INTEGER,
        territorio_nome TEXT,
        auditoria_criado_em TEXT,
        auditoria_atualizado_em TEXT,
        auditoria_indicador_ativo INTEGER,
        local_updated_at TEXT NOT NULL,
        server_updated_at TEXT,
        synced_at TEXT,
        dirty INTEGER NOT NULL DEFAULT 0,
        deleted INTEGER NOT NULL DEFAULT 0,
        sync_error TEXT,
        sync_attempt_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_vendedores_dirty ON $vendedoresTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_vendedores_deleted ON $vendedoresTable (deleted)',
    );
  }

  Future<void> _createSyncQueueTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $syncQueueTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_operation_id TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        idempotency_key TEXT NOT NULL,
        payload TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        next_retry_at TEXT NOT NULL,
        last_attempt_at TEXT,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'pending',
        last_error TEXT
      )
      ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_queue_status_created ON $syncQueueTable (status, created_at)',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_sync_queue_client_operation ON $syncQueueTable (client_operation_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_queue_due ON $syncQueueTable (status, next_retry_at, created_at)',
    );
  }
}

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

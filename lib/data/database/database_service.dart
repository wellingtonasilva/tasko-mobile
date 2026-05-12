import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _dbName = 'tasko_mobile.db';
  static const _dbVersion = 9;

  static const vendedoresTable = 'vendedores';
  static const syncQueueTable = 'sync_queue';
  static const clientesTable = 'clientes';
  static const produtosTable = 'produtos';
  static const pedidosTable = 'pedidos';
  static const pedidoItensTable = 'pedido_itens';
  static const agendaVisitasTable = 'agenda_visitas';
  static const agendaVisitaCheckinsTable = 'agenda_visita_checkins';

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
    await _createClientesTable(db);
    await _createProdutosTable(db);
    await _createPedidosTable(db);
    await _createPedidoItensTable(db);
    await _createAgendaVisitasTable(db);
    await _createAgendaVisitaCheckinsTable(db);
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

    if (oldVersion < 4) {
      await _upgradeToV4(db);
    }

    if (oldVersion < 5) {
      await _upgradeToV5(db);
    }

    if (oldVersion < 6) {
      await _upgradeToV6(db);
    }

    if (oldVersion < 7) {
      await _upgradeToV7(db);
    }

    if (oldVersion < 8) {
      await _upgradeToV8(db);
    }

    if (oldVersion < 9) {
      await _upgradeToV9(db);
    }
  }

  Future<void> _upgradeToV9(Database db) async {
    await _addColumnIfNotExists(db, pedidosTable, 'sync_status', 'TEXT');
    await db.execute('''
      UPDATE $pedidosTable
      SET sync_status = CASE
        WHEN sync_error IS NOT NULL AND TRIM(sync_error) <> '' THEN 'error'
        WHEN dirty = 1 OR sincronizado = 0 THEN 'pending'
        ELSE 'synced'
      END
      WHERE sync_status IS NULL
    ''');
  }

  Future<void> _upgradeToV8(Database db) async {
    await _addColumnIfNotExists(
      db,
      pedidosTable,
      'descricao_condicao_pagamento',
      'TEXT',
    );
    await _addColumnIfNotExists(
      db,
      pedidosTable,
      'descricao_forma_pagamento',
      'TEXT',
    );
    await _addColumnIfNotExists(db, pedidosTable, 'nome_vendedor', 'TEXT');
    await _addColumnIfNotExists(
      db,
      pedidosTable,
      'nome_fantasia_cliente',
      'TEXT',
    );
    await _addColumnIfNotExists(
      db,
      pedidosTable,
      'descricao_status_tipo',
      'TEXT',
    );
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

  Future<void> _upgradeToV4(Database db) async {
    await _createClientesTable(db);
    await _createProdutosTable(db);
    await _createPedidosTable(db);
    await _createPedidoItensTable(db);
    await _createAgendaVisitasTable(db);
    await _createAgendaVisitaCheckinsTable(db);
  }

  Future<void> _upgradeToV5(Database db) async {
    await _addColumnIfNotExists(
      db,
      pedidosTable,
      'is_draft',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfNotExists(
      db,
      pedidoItensTable,
      'is_draft',
      'INTEGER NOT NULL DEFAULT 0',
    );
  }

  Future<void> _upgradeToV6(Database db) async {
    await _addColumnIfNotExists(db, pedidosTable, 'empresa_id', 'INTEGER');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_empresa_id ON $pedidosTable (empresa_id)',
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
        sync_status TEXT NOT NULL DEFAULT 'synced',
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

  Future<void> _createClientesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $clientesTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        vendedor_id INTEGER,
        codigo_cliente TEXT,
        razao_social TEXT NOT NULL,
        nome_fantasia TEXT,
        cnpj_cpf TEXT,
        inscricao_estadual TEXT,
        tipo TEXT,
        segmento TEXT,
        categoria TEXT,
        cep TEXT,
        logradouro TEXT,
        complemento TEXT,
        bairro TEXT,
        cidade TEXT,
        estado TEXT,
        latitude REAL,
        longitude REAL,
        limite_credito REAL,
        prazo_pagamento INTEGER,
        data_ultimo_pedido TEXT,
        valor_ultima_compra REAL,
        bloqueado INTEGER NOT NULL DEFAULT 0,
        motivo_bloqueio TEXT,
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
      'CREATE INDEX IF NOT EXISTS idx_clientes_vendedor ON $clientesTable (vendedor_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_clientes_dirty ON $clientesTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_clientes_deleted ON $clientesTable (deleted)',
    );
  }

  Future<void> _createProdutosTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $produtosTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        codigo_produto TEXT,
        nome_produto TEXT NOT NULL,
        descricao_produto TEXT,
        unidade_medida_id INTEGER,
        unidade_medida_nome TEXT,
        grupo_id INTEGER,
        grupo_nome TEXT,
        subgrupo_id INTEGER,
        subgrupo_nome TEXT,
        peso_liquido REAL,
        marca TEXT,
        fornecedor TEXT,
        aliquota_icms REAL,
        aliquota_ipi REAL,
        dimensao_altura REAL,
        dimensao_largura REAL,
        dimensao_profundidade REAL,
        preco_custo REAL,
        preco_sugerido REAL,
        margem_minima REAL,
        quantidade_disponivel REAL,
        quantidade_reservada REAL,
        codigos_barras_json TEXT,
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
      'CREATE INDEX IF NOT EXISTS idx_produtos_nome ON $produtosTable (nome_produto)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_produtos_dirty ON $produtosTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_produtos_deleted ON $produtosTable (deleted)',
    );
  }

  Future<void> _createPedidosTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $pedidosTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        numero_pedido TEXT,
        empresa_id INTEGER,
        cliente_id INTEGER NOT NULL,
        vendedor_id INTEGER NOT NULL,
        pedido_status_tipo_id INTEGER,
        pedido_status_tipo_nome TEXT,
        data_pedido TEXT NOT NULL,
        data_entrega_prevista TEXT,
        observacao TEXT,
        subtotal REAL NOT NULL DEFAULT 0,
        percentual_desconto REAL,
        valor_desconto REAL,
        valor_frete REAL,
        valor_total REAL NOT NULL DEFAULT 0,
        forma_pagamento_id INTEGER,
        forma_pagamento_nome TEXT,
        condicao_pagamento_id INTEGER,
        condicao_pagamento_nome TEXT,
        latitude REAL,
        longitude REAL,
        sincronizado INTEGER NOT NULL DEFAULT 0,
        criado_offline INTEGER NOT NULL DEFAULT 0,
        is_draft INTEGER NOT NULL DEFAULT 0,
        uuid_offline TEXT,
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
      'CREATE INDEX IF NOT EXISTS idx_pedidos_cliente ON $pedidosTable (cliente_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_vendedor ON $pedidosTable (vendedor_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_dirty ON $pedidosTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_deleted ON $pedidosTable (deleted)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_uuid_offline ON $pedidosTable (uuid_offline)',
    );
  }

  Future<void> _createPedidoItensTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $pedidoItensTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        pedido_id INTEGER NOT NULL,
        produto_id INTEGER NOT NULL,
        quantidade REAL NOT NULL,
        preco_unitario REAL NOT NULL,
        percentual_desconto REAL,
        valor_desconto REAL,
        valor_total REAL NOT NULL,
        auditoria_criado_em TEXT,
        auditoria_atualizado_em TEXT,
        auditoria_indicador_ativo INTEGER,
        local_updated_at TEXT NOT NULL,
        server_updated_at TEXT,
        synced_at TEXT,
        is_draft INTEGER NOT NULL DEFAULT 0,
        dirty INTEGER NOT NULL DEFAULT 0,
        deleted INTEGER NOT NULL DEFAULT 0,
        sync_error TEXT,
        sync_attempt_count INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (pedido_id) REFERENCES $pedidosTable (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedido_itens_pedido ON $pedidoItensTable (pedido_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedido_itens_dirty ON $pedidoItensTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedido_itens_deleted ON $pedidoItensTable (deleted)',
    );
  }

  Future<void> _createAgendaVisitasTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $agendaVisitasTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        data_agendada TEXT NOT NULL,
        data_realizada TEXT,
        duracao_prevista INTEGER,
        duracao_real INTEGER,
        objetivo TEXT,
        observacao TEXT,
        resultado TEXT,
        vendedor_id INTEGER NOT NULL,
        cliente_id INTEGER,
        agenda_visita_status_id INTEGER,
        agenda_visita_status_nome TEXT,
        latitude REAL,
        longitude REAL,
        pedido_gerado INTEGER NOT NULL DEFAULT 0,
        pedido_id INTEGER,
        valor_pedido REAL,
        sincronizado INTEGER NOT NULL DEFAULT 0,
        criado_offline INTEGER NOT NULL DEFAULT 0,
        uuid_offline TEXT,
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
      'CREATE INDEX IF NOT EXISTS idx_agenda_visitas_vendedor ON $agendaVisitasTable (vendedor_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_visitas_data ON $agendaVisitasTable (data_agendada)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_visitas_dirty ON $agendaVisitasTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_visitas_deleted ON $agendaVisitasTable (deleted)',
    );
  }

  Future<void> _createAgendaVisitaCheckinsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $agendaVisitaCheckinsTable (
        id INTEGER PRIMARY KEY,
        local_uuid TEXT,
        agenda_visita_id INTEGER NOT NULL,
        vendedor_id INTEGER NOT NULL,
        cliente_id INTEGER,
        checkin_tipo_id INTEGER,
        checkin_tipo_nome TEXT,
        observacao TEXT,
        latitude REAL,
        longitude REAL,
        distancia_cliente REAL,
        dentro_raio_permitido INTEGER,
        sincronizado INTEGER NOT NULL DEFAULT 0,
        uuid_offline TEXT,
        auditoria_criado_em TEXT,
        auditoria_atualizado_em TEXT,
        auditoria_indicador_ativo INTEGER,
        local_updated_at TEXT NOT NULL,
        server_updated_at TEXT,
        synced_at TEXT,
        dirty INTEGER NOT NULL DEFAULT 0,
        deleted INTEGER NOT NULL DEFAULT 0,
        sync_error TEXT,
        sync_attempt_count INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (agenda_visita_id)
          REFERENCES $agendaVisitasTable (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_checkins_visita ON $agendaVisitaCheckinsTable (agenda_visita_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_checkins_dirty ON $agendaVisitaCheckinsTable (dirty)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_checkins_deleted ON $agendaVisitaCheckinsTable (deleted)',
    );
  }

  Future<void> _upgradeToV7(Database db) async {
    await _addColumnIfNotExists(db, vendedoresTable, 'empresa_id', 'INTEGER');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_vendedores_empresa_id ON $vendedoresTable (empresa_id)',
    );

    await _addColumnIfNotExists(db, pedidosTable, 'empresa_id', 'INTEGER');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pedidos_empresa_id ON $pedidosTable (empresa_id)',
    );

    await _addColumnIfNotExists(db, clientesTable, 'empresa_id', 'INTEGER');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_clientes_empresa_id ON $clientesTable (empresa_id)',
    );

    await _addColumnIfNotExists(db, produtosTable, 'empresa_id', 'INTEGER');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_produtos_empresa_id ON $produtosTable (empresa_id)',
    );

    await _addColumnIfNotExists(
      db,
      agendaVisitasTable,
      'empresa_id',
      'INTEGER',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_agenda_visitas_empresa_id ON $agendaVisitasTable (empresa_id)',
    );
  }
}

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';

/// Enum para status visual do pedido na UI
enum PedidoSyncStatus { sincronizado, pendente, erro }

/// Helper para determinar o status de sincronização do pedido
class PedidoItemStatusHelper {
  /// Determina o status visual do pedido
  static PedidoSyncStatus getStatus({required PedidoResponse pedido}) {
    if (pedido.syncStatus == 'error') {
      return PedidoSyncStatus.erro;
    }
    if (pedido.syncStatus == 'processing' || pedido.syncStatus == 'pending') {
      return PedidoSyncStatus.pendente;
    }
    if (pedido.sincronizado || pedido.syncStatus == 'synced') {
      return PedidoSyncStatus.sincronizado;
    }
    return PedidoSyncStatus.pendente;
  }
}

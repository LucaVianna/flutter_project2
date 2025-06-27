import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../home/domain/entities/order_model.dart';
import '../../../home/presentation/providers/order_provider.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  // Mapa para associar o status do pedido a um estilo (cor, texto, ícone)
  Map<String, dynamic> _getStatusStyle(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return {'text': 'Entregue', 'color': Colors.green, 'icon': Icons.check_circle};
      case OrderStatus.shipped:
        return {'text': 'Enviado', 'color': Colors.blue, 'icon': Icons.local_shipping};
      case OrderStatus.cancelled:
        return {'text': 'Cancelado', 'color': Colors.red, 'icon': Icons.cancel};
      default:
        return {'text': 'Pendente', 'color': Colors.orange, 'icon': Icons.pending};
    }
  }

  // Função auxiliar para mostrar um menu de mudança de status
  void _showStatusMenu(BuildContext context, OrderProvider provider, OrderModel order) {
    showModalBottomSheet(
      context: context, 
      builder: (ctx) {
        return Wrap(
          children: OrderStatus.values.map((status) {
            return ListTile(
              leading: Icon(
                _getStatusStyle(status)['icon'], // Usaremos um ícone para cada status
                color: _getStatusStyle(status)['color'],
              ),
              title: Text(
                _getStatusStyle(status)['text']
              ),
              onTap: () async {
                Navigator.of(ctx).pop();
                await provider.updateOrderStatus(order.id, status);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // Widget auxiliar para criar as linhas de detalhe (DATA E TOTAL DO PEDIDO)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciar Pedidos',
          style: TextStyle(
              fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(context, orderProvider),
    );
  }

  // Widget auxiliar para construir o corpo da tela de acordo com o estado
  Widget _buildBody(BuildContext context, OrderProvider provider) {
    // 1. O provider já foi buscado, aqui apenas usamos os dados dele
    if (provider.isAdminLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.error!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => provider.listenToAllOrdersForAdmin(), 
              child: const Text(
                'Tentar Novamente'
              ),
            ),
          ],
        ),
      );
    }

    // Estado de Sucesso
    final allOrders = provider.allOrders;

    if (allOrders.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum pedido cadastrado.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: allOrders.length,
      itemBuilder: (ctx, index) {
        final order = allOrders[index];
        final statusStyle = _getStatusStyle(order.status);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: ExpansionTile(
            title: Text(
              'Pedido #${order.id.substring(0, 6)}...'
            ),
            subtitle: Text(
              'Cliente ID: ...${order.userId.substring(order.userId.length - 5)}'
            ),
            trailing: Chip(
              label: Text(
                statusStyle['text'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusStyle['color'],
            ),
            children: [
              // USA O WIDGET AUXILIAR
              _buildDetailRow('Data: ', DateFormat('dd/MM/yy HH:mm', 'pt_BR').format(order.createdAt)),
              _buildDetailRow('Total: ', 'R\$ ${order.totalPrice.toStringAsFixed(2)}'),
              const Divider(),
              const Text(
                'Itens',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              ...order.items.map((item) => Padding (
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Text(
                  '• ${item.quantity}x ${item.productName}',
                ),
              )),

              const Divider(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showStatusMenu(context, provider, order), 
                  label: const Text(
                    'Alterar Status'
                  ),
                  icon: const Icon(Icons.edit_note),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
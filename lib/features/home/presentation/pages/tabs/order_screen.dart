// Caminho lib/features/home/presentation/pages/tabs/explore_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../presentation/domain/entities/order_model.dart';
import '../../providers/order_provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  // Um mapa para associar o status do pedido a uma cor e texto
  Map<String, dynamic> _getStatusStyle(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return {'text': 'Entregue', 'color': Colors.green};
      case OrderStatus.shipped:
        return {'text': 'Enviado', 'color': Colors.blue};
      case OrderStatus.cancelled:
        return {'text': 'Cancelado', 'color': Colors.red};
      default:
        return {'text': 'Pendente', 'color': Colors.orange};
    }
  }

  @override
  Widget build(BuildContext context) {
    // Assina esta tela às mudanças do OrderProvider
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Meus Pedidos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(context, orderProvider),
    );
  }

  // Widget auxiliar para construir o corpo da tela de acordo com o estado
  Widget _buildBody(BuildContext context, OrderProvider provider) {
    // 1. Estado de Carregamento
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 2. Estado de Erro
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
              onPressed: () => provider.listenToOrders(), 
              child: const Text(
                'Tentar Novamente',
              ),
            ),
          ],
        ),
      );
    }

    // 3. Etado de Lista Vazia
    if (provider.orders.isEmpty) {
      return const Center(
        child: Text(
          'Você ainda não fez nenhum pedido.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // 4. Estado de Sucesso (com dados)
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: provider.orders.length,
      itemBuilder: (context, index) {
        final order = provider.orders[index];
        final statusStyle = _getStatusStyle(order.status);

        // Usamos um ExpansionTile para criar um card "sanfona"
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ExpansionTile(
            // --- TÍTULO DO CARD (VÍSIVEL QUANDO FECHADO)
            title: Text(
              'Pedido #${order.id.substring(0, 6)}...',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(order.createdAt),
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

            // CONTEÚDO DO CARD (VISÍVEL QUANDO ABERTO)
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Itens do Pedido:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Divider(),
                    // Mapeia cada item do pedido para um ListTile
                    ...order.items.map((item) => ListTile(
                      dense: true,
                      leading: Text('${item.quantity}x'),
                      title: Text(item.productName),
                      trailing: Text(
                        'R\$ ${item.priceAtTimeOfOrder.toStringAsFixed(2)}'
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },      
    );
  }
}
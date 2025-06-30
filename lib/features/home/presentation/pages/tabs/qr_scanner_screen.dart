import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  // Controlador para a câmera do scanner
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false; // Evita escanear múltiplos códigos de uma vez

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Escanear Cupom'
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // O widget da câmera que faz todo o trabalho
          MobileScanner(
            controller: _scannerController,
            // O que fazer quando um código é detectado
            onDetect: (capture) async {
              // Se já estamos processando um código, ignora os próximos
              if (_isProcessing) return;

              setState(() { _isProcessing = true; });

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  // Pausa a câmera
                  _scannerController.stop();
                

                  // Chama o nosso provider para aplicar o cupom
                  final cartProvider = context.read<CartProvider>();
                  // --- Chama tudo antes do await ---
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final resultMessage = await cartProvider.applyCoupon(code);

                  // Após a operação, se a tela ainda estiver visível
                  if (mounted) {
                    // Mostra o resultado em uma SnackBar
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(resultMessage),
                        backgroundColor: resultMessage.contains('sucesso') ? Colors.green : Colors.red,
                      ),
                    );
                  // Volta para a tela do carrinho
                  navigator.pop();
                  }
                }
              } else {
                // Se não detectou nada válido, permite novo scan
                setState(() { _isProcessing = false; });
              }
            },
          ),

          // --- Um overlay visual para ajudar o usuário
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Positioned(
            bottom: 100,
            child: Text(
              'Aponte a câmera para o QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black54
              ),
            ),
          ),
        ],
      ),
    );
  }
}
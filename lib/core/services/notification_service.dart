import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Cria uma instância singleton do nosso serviço
  // Garante que teremos apenas uma instância dele em todo o app
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  // Instância do plugin de notificações
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Inicializa as configurações do plugin de notificações
  Future<void> initialize() async {
    // Configurações de inicialização para Android
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher'); // Usa o ícone padrão do app

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    // Inicializa o plugin com as configurações
    await _notificationsPlugin.initialize(initializationSettings);

    // Pede permissão de notificações para o usuário no Android (Android 13+)
    _requestAndroidPermission();
  }

  // Pede a parmissão de notificação no Android
  Future<void> _requestAndroidPermission() async {
    await _notificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // Mostra uma notificação simples
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Detalhes da notificação para Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
     'order_status_channel', // ID do canal
     'Atualizações de Pedido', // Nome do canal
     channelDescription: 'Notificações sobre mudanças no status do seu pedido',
     importance: Importance.max,
     priority: Priority.high, 
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Mostra a notificação
    await _notificationsPlugin.show(
      id, 
      title, 
      body, 
      notificationDetails
    );
  }
}
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/services/product_service.dart';
import '../domain/entities/product_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Provider para gerenciar o estado dos produtos da loja
class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  AuthProvider _authProvider; // NOVA DEPENDÊNCIA
  StreamSubscription? _productsSubscription;

  // ESTADOS INTERNOS
  List<ProductModel> _products = [];
  bool _isLoading = true; // Inicia carregando
  String? _error;

  // GETTERS PÚBLICOS
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Construtor: inicia a escuta dos produtos assim que o provider é criado
  ProductProvider(this._authProvider) {
    _listenToProducts();
  }

  // Usando pelo ProxyProvider para atualizar a dependência e reiniciar a escuta
  void updateDependencies(AuthProvider authProvider) {
    // Se o usuário mudou, reinicia a busca por produtos
    if (_authProvider.currentUser?.uid != authProvider.currentUser?.uid) {
      _authProvider = authProvider;
      _listenToProducts();
    }
  }

  // Re(INICIA) a escuta do stream de produtos
  void _listenToProducts() {
    _isLoading = true;
    notifyListeners();

    // Cancela a escuta anterior para evitar leaks
    _productsSubscription?.cancel();

    // Se o usuário não estiver logado, não tenta buscar produtos
    if (_authProvider.currentUser == null) {
      _products = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _productsSubscription = _productService.getProductsStream().listen(
     (products) {
      // Sucesso: atualiza a lista de produtos
      _products = products;
      _isLoading = false;
      _error = null;
      notifyListeners();
     }, onError: (e) {
      // Erro: atualiza a mensagem de erro
      _error = 'Não foi possível carregar os produtos.';
      _isLoading = false;
      notifyListeners();
     },
    );
  }

  // Adiciona um novo produto ao Firestore
  // Retorna 'true' em sucesso e 'false' em falha
  Future<bool> addProduct({
    required String name,
    required String description,
    required String nutrition,
    required String weight,
    required double price,
    required String imagePath,
  }) async {
    // Cria um novo obj ProductModel. o ID será gerado pelo Firestore, por isso passamos um ID vazio aqui
    final newProduct = ProductModel(
      id: '',
      name: name, 
      description: description, 
      nutrition: nutrition, 
      weight: weight, 
      price: price, 
      active: true, // Novos produtos são ativos por padrão
      imagePath: imagePath
    );

    try {
      await _productService.addProduct(newProduct);
      // Não precisa chamar notifyListeners() ou atualizar a lista, o stream já fará isso automaticamente
      return true;
    } catch (e) {
      print('Erro no ProdutProvider ao adicionar produto: $e');
      return false;
    }
  }

  // Limpa os recursos, cancelando a inscrição do stream para evitar memory leaks
  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
// lib/features/home/presentation/providers/product_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/services/product_service.dart';
import '../../domain/entities/product_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Provider para gerenciar o estado dos produtos da loja
class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  AuthProvider _authProvider; // NOVA DEPENDÊNCIA

  // Stream para os clientes (produtos ativos)
  StreamSubscription? _productsSubscription;
  List<ProductModel> _products = [];

  // --- NOVO: STREAM PARA OS ADMINS (TODOS OS PRODUTOS)
  StreamSubscription? _allProductsSubscription;
  List<ProductModel> _allProducts = [];

  // ESTADOS INTERNOS
  bool _isShopLoading = true;
  bool _isAdminLoading = true;
  String? _error;

  // GETTER PARA A LOJA DO CLIENTE
  List<ProductModel> get products => _products;

  // --- NOVO: GETTER PARA A TELA DO ADMIN
  List<ProductModel> get allProducts => _allProducts;

  // GETTERS PÚBLICOS
  bool get isShopLoading => _isShopLoading;
  bool get isAdminLoading => _isAdminLoading;
  String? get error => _error;

  // Construtor: inicia a escuta dos produtos assim que o provider é criado
  ProductProvider(this._authProvider) {
    // Inicia ambas as escutas
    listenToProducts();
    listenToAllProductsForAdmin();
  }

  // Usando pelo ProxyProvider para atualizar a dependência e reiniciar a escuta
  void updateDependencies(AuthProvider authProvider) {
    // ESTA CLÁUSULA IF FOI DESATIVADA PARA MELHORAR AS ATUALIZAÇÕES EM TEMPO REAL
    // NÃO É MAIS NECESSÁRIO REINICIAR O APP EM ALGUNS CASOS

    // if (_authProvider.currentUser?.uid != authProvider.currentUser?.uid) {
    _authProvider = authProvider;
    listenToProducts();
    listenToAllProductsForAdmin();
    // }
  }

  // Re(INICIA) a escuta do stream do cliente
  void listenToProducts() {
    _isShopLoading = true;
    notifyListeners();

    // Cancela a escuta anterior para evitar leaks
    _productsSubscription?.cancel();

    // Se o usuário não estiver logado, não tenta buscar produtos
    if (_authProvider.currentUser == null) {
      _products = [];
      _isShopLoading = false;
      notifyListeners();
      return;
    }

    _productsSubscription = _productService.getProductsStream().listen(
     (products) {
      // Sucesso: atualiza a lista de produtos
      _products = products;
      _isShopLoading = false;
      _error = null;
      notifyListeners();
     }, onError: (e) {
      // Erro: atualiza a mensagem de erro
      _error = 'Não foi possível carregar os produtos.';
      _isShopLoading = false;
      notifyListeners();
     },
    );
  }

  // --- NOVO: Escuta TODOS os produtos para a tela do admin
  void listenToAllProductsForAdmin() {
    _isAdminLoading = true;
    notifyListeners();
    _allProductsSubscription?.cancel();

    // Apenas admins podem escutar todos os produtos
    if (_authProvider.currentUser?.isAdmin ?? false) {
      _allProductsSubscription = _productService.getAllProductsStreamForAdmin().listen((products) {
        _allProducts = products;
        _isAdminLoading = false;
        notifyListeners();
      }, onError: (e) {
        _error = 'Não foi possível carregar a lista de gerenciamento.';
        _isAdminLoading = false;
        notifyListeners();
      });
    } else {
      _allProducts = [];
      _isAdminLoading = false;
      notifyListeners();
    }   
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

  // --- NOVO: Atualiza um produto existente
  Future<bool> updateProduct(ProductModel product) async {
    try {
      await _productService.updateProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- NOVO: Deleta um produto
  Future<bool> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Limpa os recursos, cancelando a inscrição do stream para evitar memory leaks
  @override
  void dispose() {
    _productsSubscription?.cancel();
    _allProductsSubscription?.cancel();
    super.dispose();
  }
}
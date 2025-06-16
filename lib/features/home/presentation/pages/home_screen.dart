import 'package:flutter/material.dart';
import 'tabs/shop_screen.dart';
import 'tabs/favorite_screen.dart';
import 'tabs/explore_screen.dart';
import 'tabs/cart_screen.dart';
import 'tabs/profile_screen.dart';
import '../../../../core/utils/funcs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index para navegação na Bottom Navigation Bar
  int _selectedIndex = 0;

  // Inicia carrinho vazio
  List<Map<String, dynamic>> cartItems = [];

  // Inicia a lista de telas da Bottom Navigation Bar vazia
  late final List<Widget> _screens = [];

  @override
  // Preenche a lista de telas da Bottom Navigation Bar
  void initState() {
    super.initState();
    _screens.addAll([
      // Recursos utilizados (como funções e listas) são fornecidos em cada tela adicionada
      ShopScreen(addToCart: (product, quantity) => addToCart(cartItems, product, quantity, setState)),
      ExploreScreen(),
      CartScreen(
        cartItems: cartItems,
        increaseQuantity: (productName) => increaseQuantity(cartItems, productName, setState),
        decreaseQuantity: (productName) => decreaseQuantity(cartItems, productName, setState),
        removeFromCart: (productName) => removeFromCart(cartItems, productName, setState),
      ),
      FavoriteScreen(),
      ProfileScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Tela inidicada pela Bottom Navigation Bar
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
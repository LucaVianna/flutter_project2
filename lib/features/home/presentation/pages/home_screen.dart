// Caminho lib/features/home/presentation/pages/home_screen.dart

import 'package:flutter/material.dart';
import 'tabs/shop_screen.dart';
import 'tabs/favorite_screen.dart';
import 'tabs/order_screen.dart';
import 'tabs/cart_screen.dart';
import 'tabs/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index para navegação na Bottom Navigation Bar
  int _selectedIndex = 0;

  // A lista de telas agora é simples e não passa nenhuma função
  static const List<Widget> _screens = [
    ShopScreen(),
    OrderScreen(),
    CartScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
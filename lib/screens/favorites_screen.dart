import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../widgets/cocktail_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Por ahora usamos una lista en memoria
  // En una implementación real, esto sería persistido usando SharedPreferences o una base de datos
  final List<Cocktail> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllFavorites,
            ),
        ],
      ),
      body: _favorites.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No tienes favoritos aún',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explora cócteles y agrégalos a favoritos\npara verlos aquí más tarde',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Cambiar a la pestaña de búsqueda
              // En una implementación real, esto navegaría a la pantalla de búsqueda
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.search),
            label: const Text('Buscar cócteles'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            border: Border(bottom: BorderSide(color: Colors.amber[200]!)),
          ),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.amber[800]),
              const SizedBox(width: 8),
              Text(
                '${_favorites.length} cócteles favoritos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return CocktailCard(cocktail: _favorites[index], index: index);
            },
          ),
        ),
      ],
    );
  }

  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar favoritos'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar todos los cócteles favoritos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _favorites.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favoritos eliminados')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Métodos para gestionar favoritos (serían llamados desde otras pantallas)
  void addToFavorites(Cocktail cocktail) {
    if (!_favorites.any((fav) => fav.id == cocktail.id)) {
      setState(() {
        _favorites.add(cocktail);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${cocktail.name} agregado a favoritos'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () => removeFromFavorites(cocktail),
          ),
        ),
      );
    }
  }

  void removeFromFavorites(Cocktail cocktail) {
    setState(() {
      _favorites.removeWhere((fav) => fav.id == cocktail.id);
    });
  }

  bool isFavorite(Cocktail cocktail) {
    return _favorites.any((fav) => fav.id == cocktail.id);
  }
}

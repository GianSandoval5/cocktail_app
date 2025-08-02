import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cocktail.dart';
import '../services/cocktail_service.dart';
import 'cocktail_detail_screen.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen>
    with SingleTickerProviderStateMixin {
  Cocktail? _currentCocktail;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _getRandomCocktail();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getRandomCocktail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cocktail = await CocktailService.getRandomCocktail();
      if (mounted) {
        setState(() {
          _currentCocktail = cocktail;
          _isLoading = false;
        });
        _animationController.reset();
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener cóctel aleatorio: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cóctel Aleatorio'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _getRandomCocktail,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Preparando tu cóctel...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : _currentCocktail == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No se pudo cargar el cóctel',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getRandomCocktail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Intentar de nuevo'),
                  ),
                ],
              ),
            )
          : _buildCocktailCard(),
      floatingActionButton: _currentCocktail != null
          ? FloatingActionButton.extended(
              onPressed: _isLoading ? null : _getRandomCocktail,
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shuffle),
              label: const Text('Otro cóctel'),
            )
          : null,
    );
  }

  Widget _buildCocktailCard() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen del cóctel
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: CachedNetworkImage(
                        imageUrl: _currentCocktail!.image ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.local_bar,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Información del cóctel
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentCocktail!.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (_currentCocktail!.category != null) ...[
                              Chip(
                                label: Text(_currentCocktail!.category!),
                                backgroundColor: Colors.amber[100],
                                labelStyle: TextStyle(color: Colors.amber[800]),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (_currentCocktail!.alcoholic != null)
                              Chip(
                                label: Text(_currentCocktail!.alcoholic!),
                                backgroundColor:
                                    _currentCocktail!.alcoholic == 'Alcoholic'
                                    ? Colors.red[100]
                                    : Colors.green[100],
                                labelStyle: TextStyle(
                                  color:
                                      _currentCocktail!.alcoholic == 'Alcoholic'
                                      ? Colors.red[700]
                                      : Colors.green[700],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_currentCocktail!.glass != null) ...[
                          Row(
                            children: [
                              Icon(Icons.wine_bar, color: Colors.amber[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Servir en: ${_currentCocktail!.glass}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Ingredientes
                        if (_currentCocktail!.ingredients.isNotEmpty) ...[
                          Text(
                            'Ingredientes:',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ..._currentCocktail!.ingredients.map((ingredient) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fiber_manual_record,
                                    size: 8,
                                    color: Colors.amber[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${ingredient.measure ?? ''} ${ingredient.name}'
                                          .trim(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                        ],
                        // Botón para ver detalles completos
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CocktailDetailScreen(
                                    cocktail: _currentCocktail!,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Ver receta completa',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

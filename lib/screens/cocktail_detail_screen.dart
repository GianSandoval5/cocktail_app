import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cocktail.dart';
import '../services/cocktail_service.dart';

class CocktailDetailScreen extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailDetailScreen({super.key, required this.cocktail});

  @override
  State<CocktailDetailScreen> createState() => _CocktailDetailScreenState();
}

class _CocktailDetailScreenState extends State<CocktailDetailScreen>
    with TickerProviderStateMixin {
  bool _isFavorite = false;
  Cocktail? _fullCocktail;
  bool _isLoadingDetails = false;
  late AnimationController _favoriteController;
  late AnimationController _contentController;
  late Animation<double> _favoriteAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Iniciar animación de contenido
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentController.forward();
      }
    });

    // Cargar detalles completos si faltan
    _loadFullCocktailDetails();
  }

  Future<void> _loadFullCocktailDetails() async {
    // Si ya tiene ingredientes e instrucciones, no necesitamos cargar más
    if (widget.cocktail.ingredients.isNotEmpty &&
        widget.cocktail.instructions != null &&
        widget.cocktail.instructions!.isNotEmpty) {
      setState(() {
        _fullCocktail = widget.cocktail;
      });
      return;
    }

    // Cargar detalles completos de la API
    setState(() {
      _isLoadingDetails = true;
    });

    try {
      final fullCocktail = await CocktailService.getCocktailById(
        widget.cocktail.id,
      );
      if (mounted && fullCocktail != null) {
        setState(() {
          _fullCocktail = fullCocktail;
          _isLoadingDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDetails = false;
          _fullCocktail = widget.cocktail; // Usar datos básicos como fallback
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar detalles: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Getter para obtener el cóctel con datos completos
  Cocktail get currentCocktail => _fullCocktail ?? widget.cocktail;

  @override
  void dispose() {
    _favoriteController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _favoriteController.forward().then((_) {
      _favoriteController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isFavorite ? Icons.favorite : Icons.heart_broken,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              _isFavorite
                  ? '${widget.cocktail.name} agregado a favoritos'
                  : '${widget.cocktail.name} eliminado de favoritos',
            ),
          ],
        ),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.cocktail.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.cocktail.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
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
                  // Gradiente para mejorar la legibilidad del título
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              AnimatedBuilder(
                animation: _favoriteAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _favoriteAnimation.value,
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  );
                },
              ),
            ],
          ),
          // Contenido
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner de carga de detalles
                          if (_isLoadingDetails)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber[200]!),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.amber[600],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Cargando detalles del cóctel...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Chips con información básica
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (widget.cocktail.category != null)
                                Chip(
                                  label: Text(widget.cocktail.category!),
                                  backgroundColor: Colors.amber[100],
                                  labelStyle: TextStyle(
                                    color: Colors.amber[800],
                                  ),
                                  avatar: Icon(
                                    Icons.category,
                                    size: 18,
                                    color: Colors.amber[800],
                                  ),
                                ),
                              if (widget.cocktail.alcoholic != null)
                                Chip(
                                  label: Text(
                                    widget.cocktail.alcoholic == 'Alcoholic'
                                        ? 'Con alcohol'
                                        : 'Sin alcohol',
                                  ),
                                  backgroundColor:
                                      widget.cocktail.alcoholic == 'Alcoholic'
                                      ? Colors.red[100]
                                      : Colors.green[100],
                                  labelStyle: TextStyle(
                                    color:
                                        widget.cocktail.alcoholic == 'Alcoholic'
                                        ? Colors.red[700]
                                        : Colors.green[700],
                                  ),
                                  avatar: Icon(
                                    widget.cocktail.alcoholic == 'Alcoholic'
                                        ? Icons.wine_bar
                                        : Icons.local_cafe,
                                    size: 18,
                                    color:
                                        widget.cocktail.alcoholic == 'Alcoholic'
                                        ? Colors.red[700]
                                        : Colors.green[700],
                                  ),
                                ),
                              if (widget.cocktail.glass != null)
                                Chip(
                                  label: Text(widget.cocktail.glass!),
                                  backgroundColor: Colors.blue[100],
                                  labelStyle: TextStyle(
                                    color: Colors.blue[800],
                                  ),
                                  avatar: Icon(
                                    Icons.wine_bar,
                                    size: 18,
                                    color: Colors.blue[800],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Ingredientes
                          if (currentCocktail.ingredients.isNotEmpty) ...[
                            _buildSectionTitle('Ingredientes', Icons.eco),
                            const SizedBox(height: 12),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: currentCocktail.ingredients.map((
                                    ingredient,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          // Imagen del ingrediente
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: ingredient.imageUrl,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.eco,
                                                      size: 20,
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons.eco,
                                                          size: 20,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Información del ingrediente
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ingredient.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                if (ingredient.measure != null)
                                                  Text(
                                                    ingredient.measure!,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Instrucciones
                          if (currentCocktail.instructions != null) ...[
                            _buildSectionTitle('Preparación', Icons.list_alt),
                            const SizedBox(height: 12),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  currentCocktail.instructions!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // Mensaje cuando no hay ingredientes o instrucciones
                          if (!_isLoadingDetails &&
                              currentCocktail.ingredients.isEmpty &&
                              (currentCocktail.instructions == null ||
                                  currentCocktail.instructions!.isEmpty)) ...[
                            const SizedBox(height: 24),
                            Card(
                              color: Colors.orange[50],
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange[600],
                                      size: 32,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Información limitada',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Los detalles completos de ingredientes y preparación no están disponibles para este cóctel.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber[800], size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.amber[800],
          ),
        ),
      ],
    );
  }
}

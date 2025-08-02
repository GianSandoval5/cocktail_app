import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../services/cocktail_service.dart';
import '../widgets/cocktail_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> _categories = [];
  List<Cocktail> _cocktails = [];
  String? _selectedCategory;
  bool _isLoading = false;
  bool _isLoadingCategories = true;

  // Categorías predefinidas con iconos
  final Map<String, IconData> _categoryIcons = {
    'Ordinary Drink': Icons.local_bar,
    'Cocktail': Icons.wine_bar,
    'Milk / Float / Shake': Icons.local_cafe,
    'Other/Unknown': Icons.help_outline,
    'Cocoa': Icons.coffee,
    'Shot': Icons.local_drink,
    'Coffee / Tea': Icons.free_breakfast,
    'Homemade Liqueur': Icons.home,
    'Punch / Party Drink': Icons.celebration,
    'Beer': Icons.sports_bar,
    'Soft Drink / Soda': Icons.local_drink,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final categories = await CocktailService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar categorías: $e')),
        );
      }
    }
  }

  Future<void> _loadCocktailsByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
      _cocktails.clear();
    });

    try {
      final cocktails = await CocktailService.filterByCategory(category);
      if (mounted) {
        setState(() {
          _cocktails = cocktails;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar cócteles: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          if (_selectedCategory != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _cocktails.clear();
                });
              },
            ),
        ],
      ),
      body: _isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : _selectedCategory == null
          ? _buildCategoriesList()
          : _buildCocktailsList(),
    );
  }

  Widget _buildCategoriesList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Selecciona una categoría',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber[100],
                    child: Icon(
                      _categoryIcons[category] ?? Icons.category,
                      color: Colors.amber[800],
                    ),
                  ),
                  title: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _loadCocktailsByCategory(category),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCocktailsList() {
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
              Icon(
                _categoryIcons[_selectedCategory] ?? Icons.category,
                color: Colors.amber[800],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedCategory!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              Text(
                '${_cocktails.length} cócteles',
                style: TextStyle(
                  color: Colors.amber[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _cocktails.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron cócteles en esta categoría',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _cocktails.length,
                  itemBuilder: (context, index) {
                    return CocktailCard(
                      cocktail: _cocktails[index],
                      index: index,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../services/cocktail_service.dart';
import '../widgets/cocktail_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Cocktail> _cocktails = [];
  bool _isLoading = false;
  String _searchType = 'name'; // 'name', 'ingredient', 'letter'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCocktails(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    List<Cocktail> results = [];

    try {
      switch (_searchType) {
        case 'name':
          results = await CocktailService.searchByName(query);
          break;
        case 'ingredient':
          results = await CocktailService.filterByIngredient(query);
          break;
        case 'letter':
          if (query.length == 1) {
            results = await CocktailService.searchByFirstLetter(query);
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al buscar: $e')));
      }
    }

    if (mounted) {
      setState(() {
        _cocktails = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Cócteles'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Selector de tipo de búsqueda
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'name',
                            label: Text('Nombre'),
                            icon: Icon(Icons.local_bar),
                          ),
                          ButtonSegment(
                            value: 'ingredient',
                            label: Text('Ingrediente'),
                            icon: Icon(Icons.eco),
                          ),
                          ButtonSegment(
                            value: 'letter',
                            label: Text('Letra'),
                            icon: Icon(Icons.abc),
                          ),
                        ],
                        selected: {_searchType},
                        onSelectionChanged: (Set<String> selected) {
                          setState(() {
                            _searchType = selected.first;
                            _cocktails.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Campo de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _getHintText(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _cocktails.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: _searchCocktails,
                  textInputAction: TextInputAction.search,
                ),
                const SizedBox(height: 8),
                // Botón de búsqueda
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _searchController.text.isNotEmpty
                        ? () => _searchCocktails(_searchController.text)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Buscar'),
                  ),
                ),
              ],
            ),
          ),
          // Resultados
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cocktails.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Busca tu cóctel favorito',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Puedes buscar por nombre, ingrediente o primera letra',
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
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
      ),
    );
  }

  String _getHintText() {
    switch (_searchType) {
      case 'name':
        return 'Ej: Margarita, Mojito...';
      case 'ingredient':
        return 'Ej: Vodka, Gin, Rum...';
      case 'letter':
        return 'Ej: A, B, C...';
      default:
        return 'Buscar...';
    }
  }
}

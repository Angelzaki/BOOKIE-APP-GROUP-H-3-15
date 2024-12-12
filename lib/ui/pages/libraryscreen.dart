import 'package:bookieapp/data/source/library_categorie_data.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:bookieapp/ui/store/story/story_store.dart';
import 'package:bookieapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  int selectedIndexOfCategory = 0;

  @override
  void initState() {
    super.initState();
    // final storyStore = Provider.of<StoryStore>(context, listen: false);
    // storyStore.fetchStories(id:1);  // Llamar a fetchStories sin parámetros por defecto
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Obtén el userId guardado

    if (userId != null) {
      final storyStore = Provider.of<StoryStore>(context, listen: false);
      storyStore.fetchStories(id: int.parse(userId)); // Pasa el userId como parámetro
    } else {
      // Maneja el caso donde no se encuentra el userId (opcional)
      print("userId no encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: width,
                height: height / 15,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndexOfCategory = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: selectedIndexOfCategory == index
                                ? const Color(0xFF4261F9)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: selectedIndexOfCategory == index ? 21 : 18,
                              color: selectedIndexOfCategory == index
                                  ? AppConstantsColor.lightTextColor
                                  : AppConstantsColor.unSelectedTextColor,
                              fontWeight: selectedIndexOfCategory == index
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search, color: Color(0xFF4261F9)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF4261F9), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF4261F9), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF4261F9), width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Observer(  // Usar Observer de MobX
        builder: (_) {
          final storyStore = Provider.of<StoryStore>(context);
          if (storyStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (storyStore.errorMessage.isNotEmpty) {
            return Center(child: Text(storyStore.errorMessage));
          }
          if (storyStore.stories.isEmpty) {
            return const Center(child: Text('No hay historias disponibles.'));
          }
          return _getSelectedCategoryView(storyStore);
        },
      ),
    );
  }

  Widget _getSelectedCategoryView(StoryStore storyStore) {
    switch (selectedIndexOfCategory) {
      case 0:
        return buildGridView(storyStore);
      case 1:
        return const Center(child: Text("En curso"));
      case 2:
        return const Center(child: Text("Terminados"));
      default:
        return const Center(child: Text("No category selected"));
    }
  }

  Widget buildGridView(StoryStore storyStore) {
    final items = storyStore.stories ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(item.title!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.favorite_border, color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.title!,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}


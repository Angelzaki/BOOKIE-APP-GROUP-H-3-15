import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('lib/ui/assets/images/logo.jpeg'),
            ),
            const SizedBox(width: 10),
            const Text('Hola, Maria!'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Continuar leyendo'),
            _buildBookList(context, [
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg'
            ]),
            _buildSectionTitle('Cerca de tu ubicación'),
            _buildBookList(context, [
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg'
            ]),
            _buildSectionTitle('Recomendados para ti'),
            _buildBookList(context, [
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg'
            ]),
            _buildSectionTitle('Novedades'),
            _buildBookList(context, [
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg'
            ]),
            _buildSectionTitle('Tendencias'),
            _buildBookList(context, [
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg',
              'lib/ui/assets/images/image1.jpeg'
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBookList(BuildContext context, List<String> assetPaths) {
    return SizedBox(
      height: 200, // Fixed height instead of percentage
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: assetPaths.length,
        itemBuilder: (context, index) {
          return _buildBookItem(context, assetPaths[index]);
        },
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, String assetPath) {
    return Container(
      width: 150, // Fixed width
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              assetPath, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Título del libro',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
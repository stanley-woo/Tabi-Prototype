import 'package:flutter/material.dart';
import '../models/itinerary.dart';
import '../services/api_service.dart';
import 'itinerary_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> savedItineraryIds = {};

  void toggleSaved(int id) {
    setState(() {
      if (savedItineraryIds.contains(id)) {
        savedItineraryIds.remove(id);
      } else {
        savedItineraryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore Itineraries")),
      body: FutureBuilder<List<ItineraryStatic>>(
        future: ApiService.fetchItineraries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No itineraries found."));
          }

          final List<ItineraryStatic> itineraries = snapshot.data!;

          return ListView.builder(
            itemCount: itineraries.length,
            itemBuilder: (context, index) {
              final itinerary = itineraries[index];
              final isSaved = savedItineraryIds.contains(itinerary.id);

              final photoBlocks = itinerary.blocks.whereType<PhotoBlock>();
              final heroUrl = photoBlocks.isNotEmpty ? photoBlocks.first.url : null;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItineraryDetailPage(itinerary: itinerary),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: heroUrl != null
                            ? Image.network(
                                heroUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) =>
                                    Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                                )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                                ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(itinerary.title,
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text("${itinerary.destination} • ${itinerary.days} days",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Text("By ${itinerary.userName}",
                                style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildIconStat(Icons.favorite_border, itinerary.likes),
                                _buildSaveButton(itinerary.id, isSaved),
                                _buildIconStat(Icons.call_split, itinerary.forks),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIconStat(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count.toString(), style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSaveButton(int id, bool isSaved) {
    return GestureDetector(
      onTap: () => toggleSaved(id),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey<bool>(isSaved),
          size: 20,
          color: isSaved ? Colors.teal : Colors.grey[600],
        ),
      ),
    );
  }
}
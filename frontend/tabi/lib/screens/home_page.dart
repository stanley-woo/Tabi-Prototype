import 'dart:async';
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
  late Future<List<ItineraryStatic>> _futureItineraries;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce; // optional: debounce for nicer UX
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
  void initState() {
    super.initState();
    _futureItineraries = ApiService.fetchItineraries();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Called on every keystroke (and submit).
  // Debounced so we don’t hammer the server on every single character.
  void _onSearchChanged(String term) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _futureItineraries = ApiService.fetchItineraries(search: term.trim());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchCtrl,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search For Your Next Trip…',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearchChanged(''); // reset search
                      },
                    ),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchChanged,
        ),
      ),

      // 7️⃣ Point FutureBuilder at our dynamic future
      body: FutureBuilder<List<ItineraryStatic>>(
        future: _futureItineraries,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final itineraries = snap.data!;
          if (itineraries.isEmpty) {
            return const Center(child: Text("No itineraries found."));
          }

          return ListView.builder(
            itemCount: itineraries.length,
            itemBuilder: (context, index) {
              final it = itineraries[index];
              final isSaved = savedItineraryIds.contains(it.id);

              // pull out first photo for the hero image
              final photoBlocks = it.blocks.whereType<PhotoBlock>();
              final heroUrl =
                  photoBlocks.isNotEmpty ? photoBlocks.first.url : null;

              return InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItineraryDetailPage(itinerary: it),
                      ),
                    ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image (or placeholder)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child:
                            heroUrl != null
                                ? Image.network(
                                  heroUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                      ),

                      // Title / meta / save-row
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              it.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${it.destination} • ${it.days} days",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "By ${it.userName}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildIconStat(Icons.favorite_border, it.likes),
                                _buildSaveButton(it.id, isSaved),
                                _buildIconStat(Icons.call_split, it.forks),
                              ],
                            ),
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
        transitionBuilder:
            (child, animation) =>
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

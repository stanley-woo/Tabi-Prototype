import 'package:flutter/material.dart';
import '../models/itinerary.dart';
import '../services/api_service.dart';
import 'itinerary_detail_page.dart';

class ProfilePage extends StatefulWidget {
  final int userID;
  const ProfilePage({super.key, required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<ItineraryStatic>> _myItins;
  late Future<List<ItineraryStatic>> _myFavs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _myItins = ApiService.fetchItineraries();
    _myFavs = ApiService.fetchFavorites(widget.userID);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildList(Future<List<ItineraryStatic>> future) {
    return FutureBuilder<List<ItineraryStatic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text("So Sally Can Wait~"));
        }

        return ListView(
          children:
              list.map((it) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(it.title),
                  subtitle: Text("${it.destination} • ${it.days} days"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItineraryDetailPage(itinerary: it),
                      ),
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_on), text: "My Trips"),
            Tab(icon: Icon(Icons.bookmark), text: "Saved"),
            Tab(icon: Icon(Icons.collections), text: "Collections"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_myItins),
          _buildList(_myFavs),
          const Center(child: Text("So Sally Can't Wait~")),
        ],
      ),
    );
  }
}

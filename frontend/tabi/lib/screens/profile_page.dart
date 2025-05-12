import 'package:flutter/material.dart';
import '../data/profile_data.dart';
import '../models/itinerary.dart';
import 'itinerary_detail_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildStat(String label, Object count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage('https://picsum.photos/200'),
          ),
          const SizedBox(height: 12),
          Text(
            currentUserName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("Places Visited", placesVisitedCount),
              _buildStat("Followers", followersCount),
              _buildStat("Itineraries", myItineraries.length),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Posts, Saved, Forked
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: const Text('Profile', style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: 'Posts'), Tab(text: 'Saved'), Tab(text: 'Forked')],
          ),
        ),
        body: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  _ItineraryListView(itins: myItineraries),
                  _ItineraryListView(itins: myFavorites),
                  _ItineraryListView(itins: myForks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItineraryListView extends StatelessWidget {
  final List<ItineraryStatic> itins;
  const _ItineraryListView({Key? key, required this.itins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itins.isEmpty) {
      return const Center(child: Text('Nothing to show here.'));
    }

    return ListView.builder(
      itemCount: itins.length,
      itemBuilder: (context, index) {
        final itin = itins[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          title: Text(itin.title),
          subtitle: Text('${itin.destination} • ${itin.days} days'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItineraryDetailPage(itinerary: itin),
              ),
            );
          },
        );
      },
    );
  }
}

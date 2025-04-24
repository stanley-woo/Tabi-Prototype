import 'package:flutter/material.dart';
import '../models/itinerary.dart';
import 'video_player_widget.dart';

class ItineraryDetailPage extends StatefulWidget {
    final ItineraryStatic itinerary;

    const ItineraryDetailPage({super.key, required this.itinerary});

    @override
    State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
    bool _showContent = true;

    @override
    Widget build(BuildContext context) {
        final itinerary = widget.itinerary;

        return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                // A) The Header row -> refer to Tabi Figma
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        // The fork saved button
                                        TextButton(
                                            onPressed: () {
                                                // ToDo later to establish the functionality
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                ),
                                            ),
                                            child: const Text(
                                                "Fork Saved",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                ),
                                            ),
                                        ),

                                        // Center title (italic, truncates with “…” if too long)
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    itinerary.title,
                                                    style: const TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                ),
                                            ),
                                        ),
                                        
                                        // Right “Publish” button
                                        TextButton(
                                            onPressed: () {
                                                // TODO for the button publish actions
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                ),
                                            ),
                                            child: const Text(
                                                "Publish",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 16),

                                // B.) Adding the Hero Image (refer to tabi figma)
                                if(!itinerary.photoUrls.isEmpty) ...[
                                    ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: AspectRatio(
                                        aspectRatio: 16/9,
                                        child: Image.network(
                                            itinerary.photoUrls.first,
                                            fit: BoxFit.cover,
                                            ),
                                        ),
                                    ),
                                    const SizedBox(height: 16),
                                ],
                                
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}

class _PhotoBlock extends StatelessWidget {
    final String url;

    const _PhotoBlock({required this.url});

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(url, fit: BoxFit.cover),
            ),
        );
    }
}

class _VideoBlock extends StatelessWidget {
    final String url;

    const _VideoBlock({required this.url});

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AspectRatio(
                aspectRatio: 16/9,
                child: VideoPlayerWidget(videoUrl: url),
            ),
        );
    }
}

class _BottomActionBar extends StatelessWidget {
    final bool isVisible;
    final VoidCallback onToggle;

    const _BottomActionBar({
        required this.isVisible,
        required this.onToggle,
    });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.repeat), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                    IconButton(
                        icon: Icon(isVisible ? Icons.visibility_off: Icons.visibility),
                        onPressed: onToggle,
                    ),
                ],
            ),
        );
    }
}
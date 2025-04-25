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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A) Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              itinerary.title,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          itinerary.userName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // B–D) Blocks loop
                    ...itinerary.blocks.map((block) {
                      if (block is TextBlock) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            block.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(height: 1.5),
                            textAlign: TextAlign.justify,
                          ),
                        );
                      } else if (block is PhotoBlock) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 600,
                                maxHeight: 300,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  block.url,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (block is VideoBlock) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: VideoPlayerWidget(
                                    videoUrl: block.url,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} // ← Make sure this closes the State class



                                // // A) The Header row -> refer to Tabi Figma
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //         // The fork saved button
                                //         TextButton(
                                //             onPressed: () {
                                //                 // ToDo later to establish the functionality
                                //             },
                                //             style: TextButton.styleFrom(
                                //                 backgroundColor: Colors.grey[200],
                                //                 shape: RoundedRectangleBorder(
                                //                     borderRadius: BorderRadius.circular(8),
                                //                 ),
                                //                 padding: const EdgeInsets.symmetric(
                                //                     horizontal: 12,
                                //                     vertical: 6,
                                //                 ),
                                //             ),
                                //             child: const Text(
                                //                 "Fork Saved",
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 14,
                                //                 ),
                                //             ),
                                //         ),

                                //         // Center title (italic, truncates with “…” if too long)
                                //         Expanded(
                                //             child: Center(
                                //                 child: Text(
                                //                     itinerary.title,
                                //                     style: const TextStyle(
                                //                         fontStyle: FontStyle.italic,
                                //                         fontSize: 16,
                                //                         fontWeight: FontWeight.w500,
                                //                     ),
                                //                     overflow: TextOverflow.ellipsis,
                                //                 ),
                                //             ),
                                //         ),
                                        
                                //         // Right “Publish” button
                                //         TextButton(
                                //             onPressed: () {
                                //                 // TODO for the button publish actions
                                //             },
                                //             style: TextButton.styleFrom(
                                //                 backgroundColor: Colors.grey[200],
                                //                 shape: RoundedRectangleBorder(
                                //                     borderRadius: BorderRadius.circular(8),
                                //                 ),
                                //                 padding: const EdgeInsets.symmetric(
                                //                     horizontal: 12,
                                //                     vertical: 6,
                                //                 ),
                                //             ),
                                //             child: const Text(
                                //                 "Publish",
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 14,
                                //                 ),
                                //             ),
                                //         ),
                                //     ],
                                // ),
                                // const SizedBox(height: 16),
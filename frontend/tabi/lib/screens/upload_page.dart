import 'package:flutter/material.dart';
import '../data/profile_data.dart';
import '../models/itinerary.dart';
import 'itinerary_detail_page.dart';

class UploadPage extends StatefulWidget {
  final VoidCallback onPublishComplete;
  const UploadPage({Key? key, required this.onPublishComplete})
    : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  ItineraryStatic? _selectedItin;
  final Map<int, TextEditingController> _textControllers = {};

  @override
  void dispose() {
    // Clean up controllers when the widget is destroyed
    for (var c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _openForkModal() async {
    final ItineraryStatic? chosen = await showDialog<ItineraryStatic>(
      context: context,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Select A Trip To Fork.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children:
                          myForks.map((it) {
                            final thumb =
                                it.blocks.firstWhere(
                                      (b) => b is PhotoBlock,
                                      orElse: () => TextBlock(''),
                                    )
                                    as PhotoBlock;
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  thumb.url,
                                  width: 58,
                                  height: 58,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(it.title),
                              subtitle: Text(
                                '${it.destination} • ${it.days} days',
                              ),
                              onTap: () => Navigator.pop(ctx, it),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    if (chosen != null) {
      setState(() {
        _selectedItin = chosen;
        _textControllers.clear();
        for (var i = 0; i < chosen.blocks.length; i++) {
          final block = chosen.blocks[i];
          if (block is TextBlock) {
            _textControllers[i] = TextEditingController(text: block.content);
          }
        }
      });
    }
  }

  void _publish() {
    if (_selectedItin == null) return;

    final newBlocks = <ItineraryBlock>[];
    for (var i = 0; i < _selectedItin!.blocks.length; i++) {
      final block = _selectedItin!.blocks[i];
      if (block is TextBlock) {
        final edited = _textControllers[i]?.text ?? '';
        newBlocks.add(TextBlock(edited));
      } else if (block is PhotoBlock) {
        newBlocks.add(block);
      }
    }

    final newItin = ItineraryStatic(
      id: deomoItineraries.length + 1,
      title: _selectedItin!.title,
      destination: _selectedItin!.destination,
      days: _selectedItin!.days,
      userName: currentUserName,
      likes: 0,
      forks: 0,
      saves: 0,
      blocks: newBlocks,
    );

    deomoItineraries.add(newItin);
    myItineraries.add(newItin);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Trip Created!')));

    widget.onPublishComplete();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryDetailPage(itinerary: newItin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _selectedItin?.title ?? 'Untitled';
    final canPublish = _selectedItin != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // Remove leading / title / actions and use flexibleSpace:
        toolbarHeight: 56,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 1) Fork Saved button
                TextButton(
                  onPressed: _openForkModal,
                  child: const Text(
                    'Fork Saved',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                // 2) Centered title
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                // 3) Publish button
                TextButton(
                  onPressed: canPublish ? _publish : null,
                  child: const Text('Publish'),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          _selectedItin == null
              ? const Center(
                child: Text(
                  "Create From Scratch or Tap Fork Saved to pick a trip to edit!",
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _selectedItin!.blocks.length,
                itemBuilder: (context, index) {
                  final block = _selectedItin!.blocks[index];
                  if (block is PhotoBlock) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(block.url, fit: BoxFit.cover),
                      ),
                    );
                  } else if (block is TextBlock) {
                    final controller = _textControllers[index]!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text...',
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
    );
  }
}

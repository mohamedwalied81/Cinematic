import 'package:flutter/material.dart';
import '../Navigations/app_routes.dart';
import '../models/media_item.dart';
import '../services/local_db_service.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  static const _red = Color(0xFFE50914);
  static const _dark = Color(0xFF0D0D0D);

  List<MediaItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadList() async {
    if (mounted) setState(() => _loading = true);
    try {
      final rows = await LocalDbService.getMyList();
      if (mounted) {
        setState(() {
          _items = rows.map((r) => MediaItem.fromMap(r)).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _remove(int index) async {
    final item = _items[index];
    item.isInMyList = false;
    try {
      await LocalDbService.upsertItem(item);
    } catch (_) {}
    setState(() => _items.removeAt(index));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${item.title} removed from My List'),
      backgroundColor: _red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  Future<void> _toggleWatched(MediaItem item) async {
    setState(() {
      item.isWatched = !item.isWatched;
      if (!item.isWatched) item.userScore = null;
    });
    try {
      await LocalDbService.upsertItem(item);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dark,
      appBar: AppBar(
        backgroundColor: _dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My List',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _red))
          : _items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border,
                          color: Colors.white24, size: 72),
                      SizedBox(height: 16),
                      Text('Your list is empty',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Tap the bookmark icon on any title to save it',
                          style:
                              TextStyle(color: Colors.white30, fontSize: 13)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0xFF2C2C2C), height: 1),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: _red,
                        child: const Icon(Icons.delete_outline,
                            color: Colors.white, size: 26),
                      ),
                      onDismissed: (_) => _remove(index),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(context, AppRoutes.detail,
                              arguments: item);
                          // Reload after returning from detail in case the item
                          // was removed from the list inside DetailScreen
                          _loadList();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.imagePath,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 60,
                                    color: const Color(0xFF2C2C2C),
                                    child: const Icon(Icons.movie_outlined,
                                        color: Colors.white24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(item.year,
                                            style: const TextStyle(
                                                color: Colors.white38,
                                                fontSize: 12)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: item.type == 'movie'
                                                ? const Color(0xFF2C2C2C)
                                                : const Color(0xFF1E2C1E),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item.type == 'movie'
                                                ? 'MOVIE'
                                                : 'TV',
                                            style: TextStyle(
                                              color: item.type == 'movie'
                                                  ? Colors.white54
                                                  : Colors.green.shade400,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (item.userScore != null) ...[
                                          const SizedBox(width: 6),
                                          const Icon(Icons.star,
                                              color: _red, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            item.userScore!.toStringAsFixed(1),
                                            style: const TextStyle(
                                                color: _red, fontSize: 11),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Watched tick
                              GestureDetector(
                                onTap: () => _toggleWatched(item),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: item.isWatched
                                        ? Colors.green.shade700
                                        : const Color(0xFF2C2C2C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item.isWatched
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: item.isWatched
                                        ? Colors.white
                                        : Colors.white24,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

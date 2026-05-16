import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Navigations/app_routes.dart';
import '../models/media_item.dart';
import '../models/media_data.dart';
import '../services/local_db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const _red  = Color(0xFFE50914);
  static const _dark = Color(0xFF0D0D0D);
  static const _card = Color(0xFF1A1A1A);

  late TabController _tabController;
  List<MediaItem> _movies = [];
  List<MediaItem> _shows  = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    // First sync from Firebase so local DB is up to date
    await LocalDbService.syncFromFirebase();

    final movies = MediaData.movies
        .map((e) => MediaItem(
              id: e.id,
              title: e.title,
              year: e.year,
              genre: e.genre,
              duration: e.duration,
              description: e.description,
              imagePath: e.imagePath,
              imdbScore: e.imdbScore,
              type: e.type,
            ))
        .toList();

    final shows = MediaData.tvShows
        .map((e) => MediaItem(
              id: e.id,
              title: e.title,
              year: e.year,
              genre: e.genre,
              duration: e.duration,
              description: e.description,
              imagePath: e.imagePath,
              imdbScore: e.imdbScore,
              type: e.type,
            ))
        .toList();

    Map<String, Map<String, dynamic>> saved = {};
    try {
      saved = await LocalDbService.loadAllStates();
    } catch (_) {
      saved = {};
    }

    for (final item in [...movies, ...shows]) {
      if (saved.containsKey(item.id)) {
        item.isInMyList = saved[item.id]!['isInMyList'] == 1;
        item.isWatched  = saved[item.id]!['isWatched'] == 1;
        item.userScore  = saved[item.id]!['userScore'];
      }
    }

    if (mounted) {
      setState(() {
        _movies  = movies;
        _shows   = shows;
        _loading = false;
      });
    }
  }

  Future<void> _toggleMyList(MediaItem item) async {
    final newValue = !item.isInMyList;
    setState(() => item.isInMyList = newValue);
    item.isInMyList = newValue;
    try {
      await LocalDbService.upsertItem(item);
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(newValue
          ? '${item.title} added to My List'
          : '${item.title} removed from My List'),
      backgroundColor: _red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dark,
      appBar: AppBar(
        backgroundColor: _dark,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter_rounded, color: _red, size: 22),
            SizedBox(width: 8),
            Text(
              'CINEMATIC',
              style: TextStyle(
                color: _red,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded, color: Colors.white70),
            tooltip: 'My List',
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.myList);
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _red,
          labelColor: _red,
          unselectedLabelColor: Colors.white54,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'MOVIES'),
            Tab(text: 'TV SHOWS'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _red))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_movies),
                _buildList(_shows),
              ],
            ),
    );
  }

  Widget _buildList(List<MediaItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildCard(items[index]),
    );
  }

  Widget _buildCard(MediaItem item) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.detail, arguments: item);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    item.imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: const Color(0xFF2C2C2C),
                      child: const Center(
                        child: Icon(Icons.movie_outlined,
                            color: Colors.white24, size: 48),
                      ),
                    ),
                  ),
                ),
                if (item.isWatched)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text('WATCHED',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleMyList(item),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isInMyList
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: item.isInMyList ? _red : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5C518),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.black, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              item.imdbScore.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(item.year,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      const SizedBox(width: 8),
                      const Text('·',
                          style:
                              TextStyle(color: Colors.white30, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(item.duration,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      if (item.userScore != null) ...[
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.person, color: _red, size: 13),
                            const SizedBox(width: 3),
                            Text(
                              item.userScore!.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: _red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.genre,
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../services/local_db_service.dart';

class DetailScreen extends StatefulWidget {
  final MediaItem item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const _red = Color(0xFFE50914);
  static const _dark = Color(0xFF0D0D0D);
  static const _card = Color(0xFF1A1A1A);
  static const _yellow = Color(0xFFF5C518);

  late bool _isWatched;
  late bool _isInMyList;
  double? _userScore;

  @override
  void initState() {
    super.initState();
    _isWatched = widget.item.isWatched;
    _isInMyList = widget.item.isInMyList;
    _userScore = widget.item.userScore;
  }

  Future<void> _toggleWatched() async {
    setState(() {
      _isWatched = !_isWatched;
      if (!_isWatched) _userScore = null;
    });
    widget.item.isWatched = _isWatched;
    widget.item.userScore = _userScore;
    try {
      await LocalDbService.upsertItem(widget.item);
    } catch (_) {}
  }

  Future<void> _toggleMyList() async {
    setState(() => _isInMyList = !_isInMyList);
    widget.item.isInMyList = _isInMyList;
    try {
      await LocalDbService.upsertItem(widget.item);
    } catch (_) {}
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isInMyList ? 'Added to My List' : 'Removed from My List'),
      backgroundColor: _red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  Future<void> _showScoreDialog() async {
    double tempScore = _userScore ?? 5.0;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: _card,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Rate this title',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tempScore.toStringAsFixed(1),
                style: const TextStyle(
                    color: _yellow, fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const Text('/ 10',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 16),
              Slider(
                value: tempScore,
                min: 1,
                max: 10,
                divisions: 18,
                activeColor: _red,
                inactiveColor: const Color(0xFF2C2C2C),
                onChanged: (v) => setDlg(() => tempScore = v),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1', style: TextStyle(color: Colors.white38)),
                  Text('10', style: TextStyle(color: Colors.white38)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() {
                  _userScore = tempScore;
                  _isWatched = true;
                });
                widget.item.userScore = tempScore;
                widget.item.isWatched = true;
                try {
                  await LocalDbService.upsertItem(widget.item);
                } catch (_) {}
              },
              child:
                  const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      backgroundColor: _dark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: _dark,
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2C2C2C),
                      child: const Center(
                        child: Icon(Icons.movie_outlined,
                            color: Colors.white24, size: 64),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _dark.withValues(alpha: 0.9),
                          _dark,
                        ],
                        stops: const [0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _metaChip(item.year),
                      _metaChip(item.duration),
                      _metaChip(item.genre),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _scoreBox(
                        label: 'IMDb',
                        score: item.imdbScore.toStringAsFixed(1),
                        bg: _yellow,
                        textColor: Colors.black,
                        icon: Icons.star,
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showScoreDialog,
                        child: _scoreBox(
                          label: 'Your Score',
                          score: _userScore != null
                              ? _userScore!.toStringAsFixed(1)
                              : 'Rate',
                          bg: _userScore != null
                              ? _red
                              : const Color(0xFF2C2C2C),
                          textColor: Colors.white,
                          icon: _userScore != null
                              ? Icons.star
                              : Icons.star_border,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleWatched,
                          icon: Icon(
                            _isWatched
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 18,
                          ),
                          label:
                              Text(_isWatched ? 'Watched' : 'Mark as Watched'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isWatched
                                ? Colors.green.shade700
                                : const Color(0xFF2C2C2C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleMyList,
                          icon: Icon(
                            _isInMyList
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 18,
                          ),
                          label: Text(
                              _isInMyList ? 'In My List' : 'Add to My List'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isInMyList ? _red : const Color(0xFF2C2C2C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 24),
                  _detailRow(
                      'Type', item.type == 'movie' ? 'Movie' : 'TV Show'),
                  _detailRow('Genre', item.genre),
                  _detailRow('Year', item.year),
                  _detailRow('Duration', item.duration),
                  _detailRow('IMDb Rating',
                      '${item.imdbScore.toStringAsFixed(1)} / 10'),
                  if (_userScore != null)
                    _detailRow('Your Rating',
                        '${_userScore!.toStringAsFixed(1)} / 10'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(text,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
      );

  Widget _scoreBox({
    required String label,
    required String score,
    required Color bg,
    required Color textColor,
    required IconData icon,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    color: textColor.withValues(alpha: 0.7), fontSize: 10)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: textColor, size: 14),
                const SizedBox(width: 4),
                Text(score,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
          ],
        ),
      );
}

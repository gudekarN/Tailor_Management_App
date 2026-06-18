// ════════════════════════════════════════════════════════════════════════════
//  manager_design_gallery_screen.dart
//  Pranav Ladies Tailors — Design Gallery (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Constants
// ════════════════════════════════════════════════════════════════════════════


/// Pool of placeholder colours/icons for newly added photos.
const _kPreviewPool = [
  (Color(0xFFFFD0DC), Color(0xFFC2185B), Icons.add_a_photo_rounded),
  (Color(0xFFE8D5FF), Color(0xFF7B1FA2), Icons.camera_alt_rounded),
  (Color(0xFFFFE5CC), Color(0xFFE65100), Icons.photo_camera_rounded),
  (Color(0xFFD0F0FF), Color(0xFF0097A7), Icons.image_rounded),
  (Color(0xFFD7F5D7), Color(0xFF2E7D32), Icons.collections_rounded),
];

// ════════════════════════════════════════════════════════════════════════════
//  Data model
// ════════════════════════════════════════════════════════════════════════════

class _DesignPhoto {
  _DesignPhoto({
    required this.id,
    required this.label,
    required this.bgColor,
    required this.accentColor,
    required this.icon,
    this.tag = '',
  });
  final int      id;
  final String   label;
  final Color    bgColor;
  final Color    accentColor;
  final IconData icon;
  final String   tag;
}

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data — Blouse
// ════════════════════════════════════════════════════════════════════════════

List<_DesignPhoto> _buildBlousePhotos() => [
      _DesignPhoto(
        id: 1,
        label: 'Silk Blouse\nRound Neck',
        bgColor: const Color(0xFFF8BBD0),
        accentColor: const Color(0xFFC2185B),
        icon: Icons.checkroom_rounded,
        tag: 'Wedding',
      ),
      _DesignPhoto(
        id: 2,
        label: 'Cotton Blouse\nBoat Neck',
        bgColor: const Color(0xFFE1BEE7),
        accentColor: const Color(0xFF7B1FA2),
        icon: Icons.style_rounded,
        tag: 'Casual',
      ),
      _DesignPhoto(
        id: 3,
        label: 'Zardozi\nBlouse',
        bgColor: const Color(0xFFF5D87A),
        accentColor: const Color(0xFFB8860B),
        icon: Icons.auto_awesome_rounded,
        tag: 'Bridal',
      ),
      _DesignPhoto(
        id: 4,
        label: 'Kanjivaram\nBlouse',
        bgColor: const Color(0xFFFFCCBC),
        accentColor: const Color(0xFFE65100),
        icon: Icons.diamond_rounded,
        tag: 'Festive',
      ),
      _DesignPhoto(
        id: 5,
        label: 'Backless\nDesigner',
        bgColor: const Color(0xFFB2EBF2),
        accentColor: const Color(0xFF00838F),
        icon: Icons.star_rounded,
        tag: 'Modern',
      ),
      _DesignPhoto(
        id: 6,
        label: 'Halter Neck\nBlouse',
        bgColor: const Color(0xFFDCEDC8),
        accentColor: const Color(0xFF558B2F),
        icon: Icons.local_florist_rounded,
        tag: 'Party',
      ),
      _DesignPhoto(
        id: 7,
        label: 'Embroidered\nBlouse',
        bgColor: const Color(0xFFFFF9C4),
        accentColor: const Color(0xFFF9A825),
        icon: Icons.spa_rounded,
        tag: 'Festival',
      ),
      _DesignPhoto(
        id: 8,
        label: 'Princess Cut\nBlouse',
        bgColor: const Color(0xFFFFD0DC),
        accentColor: const Color(0xFFC2185B),
        icon: Icons.favorite_rounded,
        tag: 'Bridal',
      ),
      _DesignPhoto(
        id: 9,
        label: 'Patchwork\nBlouse',
        bgColor: const Color(0xFFD7CCC8),
        accentColor: const Color(0xFF5D4037),
        icon: Icons.grid_view_rounded,
        tag: 'Ethnic',
      ),
    ];

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data — Dress
// ════════════════════════════════════════════════════════════════════════════

List<_DesignPhoto> _buildDressPhotos() => [
      _DesignPhoto(
        id: 101,
        label: 'Anarkali\nSuit',
        bgColor: const Color(0xFFE8EAF6),
        accentColor: const Color(0xFF3949AB),
        icon: Icons.format_align_center_rounded,
        tag: 'Wedding',
      ),
      _DesignPhoto(
        id: 102,
        label: 'Salwar\nKameez',
        bgColor: const Color(0xFFF3E5F5),
        accentColor: const Color(0xFF8E24AA),
        icon: Icons.style_rounded,
        tag: 'Casual',
      ),
      _DesignPhoto(
        id: 103,
        label: 'Lehenga\nCholi',
        bgColor: const Color(0xFFFFEBEE),
        accentColor: const Color(0xFFC62828),
        icon: Icons.auto_awesome_rounded,
        tag: 'Bridal',
      ),
      _DesignPhoto(
        id: 104,
        label: 'Palazzo Suit',
        bgColor: const Color(0xFFE0F7FA),
        accentColor: const Color(0xFF0097A7),
        icon: Icons.view_week_rounded,
        tag: 'Modern',
      ),
      _DesignPhoto(
        id: 105,
        label: 'Sharara\nSet',
        bgColor: const Color(0xFFFFF3E0),
        accentColor: const Color(0xFFEF6C00),
        icon: Icons.wb_sunny_rounded,
        tag: 'Festive',
      ),
      _DesignPhoto(
        id: 106,
        label: 'Kurti\nPatiala',
        bgColor: const Color(0xFFE8F5E9),
        accentColor: const Color(0xFF2E7D32),
        icon: Icons.eco_rounded,
        tag: 'Casual',
      ),
      _DesignPhoto(
        id: 107,
        label: 'Churidar\nSuit',
        bgColor: const Color(0xFFFCE4EC),
        accentColor: const Color(0xFFD81B60),
        icon: Icons.favorite_rounded,
        tag: 'Party',
      ),
      _DesignPhoto(
        id: 108,
        label: 'Gown Design',
        bgColor: const Color(0xFFF9FBE7),
        accentColor: const Color(0xFF827717),
        icon: Icons.star_rounded,
        tag: 'Gown',
      ),
    ];

// ════════════════════════════════════════════════════════════════════════════
//  Main Screen
// ════════════════════════════════════════════════════════════════════════════

class ManagerDesignGalleryScreen extends StatefulWidget {
  const ManagerDesignGalleryScreen({super.key, this.readOnly = false});
  /// When true: FAB is hidden, long-press delete is disabled (employee mode).
  final bool readOnly;

  @override
  State<ManagerDesignGalleryScreen> createState() =>
      _ManagerDesignGalleryScreenState();
}

class _ManagerDesignGalleryScreenState
    extends State<ManagerDesignGalleryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController      _tab;
  late final List<_DesignPhoto> _blousePhotos;
  late final List<_DesignPhoto> _dressPhotos;
  int _nextId = 200;

  @override
  void initState() {
    super.initState();
    _tab          = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
    _blousePhotos = _buildBlousePhotos();
    _dressPhotos  = _buildDressPhotos();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  bool get _isManager => !widget.readOnly;

  List<_DesignPhoto> get _currentPhotos =>
      _tab.index == 0 ? _blousePhotos : _dressPhotos;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildGrid(_blousePhotos),
          _buildGrid(_dressPhotos),
        ],
      ),
      floatingActionButton: _isManager ? _buildFab() : null,
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.topbarStart, AppColors.topbarEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Gallery',
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          Text(
            '${_currentPhotos.length} designs · '
            '${_tab.index == 0 ? 'Blouse' : 'Dress'}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(46),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tab,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12.5, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12.5, fontWeight: FontWeight.w500),
            padding: const EdgeInsets.all(3),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.checkroom_rounded, size: 15),
                    const SizedBox(width: 6),
                    Text('Blouse (${_blousePhotos.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.style_rounded, size: 15),
                    const SizedBox(width: 6),
                    Text('Dress (${_dressPhotos.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────
  Widget _buildGrid(List<_DesignPhoto> photos) {
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 64,
                color: AppColors.textHint.withValues(alpha: 0.45)),
            const SizedBox(height: 14),
            Text('No designs yet',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text('Tap the camera button below to add.',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12.5, color: AppColors.textHint)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: photos.length,
      itemBuilder: (_, i) => _PhotoCell(
        photo: photos[i],
        onTap: () => _openFullScreen(photos, i),
        onLongPress:
            _isManager ? () => _confirmDelete(photos, photos[i]) : null,
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: _showActionSheet,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      child: const Icon(Icons.camera_alt_rounded, size: 26),
    );
  }

  // ── Action Sheet ───────────────────────────────────────────────────────────
  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ActionSheet(
        onTakePhoto: () {
          Navigator.pop(context);
          _navigateToPreview('Camera');
        },
        onChooseGallery: () {
          Navigator.pop(context);
          _navigateToPreview('Gallery');
        },
      ),
    );
  }

  // ── Preview navigation ─────────────────────────────────────────────────────
  Future<void> _navigateToPreview(String source) async {
    final tabIndex = _tab.index;
    final tabName  = tabIndex == 0 ? 'Blouse' : 'Dress';
    final poolIdx  = _nextId % _kPreviewPool.length;
    final (bg, accent, icon) = _kPreviewPool[poolIdx];
    final messenger          = ScaffoldMessenger.of(context);

    final newPhoto = await Navigator.push<_DesignPhoto>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _PreviewScreen(
          id: _nextId,
          bgColor: bg,
          accentColor: accent,
          icon: icon,
          source: source,
          tabName: tabName,
        ),
      ),
    );

    if (newPhoto != null && mounted) {
      setState(() {
        _nextId++;
        if (tabIndex == 0) {
          _blousePhotos.insert(0, newPhoto);
        } else {
          _dressPhotos.insert(0, newPhoto);
        }
      });
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Design added to $tabName gallery!',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Delete confirmation ────────────────────────────────────────────────────
  void _confirmDelete(List<_DesignPhoto> photos, _DesignPhoto photo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 10),
            Text('Delete Design',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          'Remove "${photo.label.replaceAll('\n', ' ')}" from the gallery?\nThis cannot be undone.',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => photos.remove(photo));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Delete',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Full screen viewer ─────────────────────────────────────────────────────
  void _openFullScreen(List<_DesignPhoto> photos, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenViewer(
          photos: photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Photo Cell
// ════════════════════════════════════════════════════════════════════════════

class _PhotoCell extends StatelessWidget {
  const _PhotoCell({
    required this.photo,
    required this.onTap,
    this.onLongPress,
  });
  final _DesignPhoto photo;
  final VoidCallback  onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: photo.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: photo.accentColor.withValues(alpha: 0.28), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: photo.accentColor.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Subtle dot-pattern background
              CustomPaint(
                  painter: _DotPatternPainter(color: photo.accentColor)),

              // Centre icon
              Center(
                child: Icon(
                  photo.icon,
                  size: 38,
                  color: photo.accentColor.withValues(alpha: 0.65),
                ),
              ),

              // Bottom gradient label
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        photo.accentColor.withValues(alpha: 0.0),
                        photo.accentColor.withValues(alpha: 0.82),
                      ],
                    ),
                  ),
                  child: Text(
                    photo.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              // Tag badge — top right
              if (photo.tag.isNotEmpty)
                Positioned(
                  top: 5, right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: photo.accentColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(photo.tag,
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),

              // Long-press indicator — top left (manager)
              if (onLongPress != null)
                Positioned(
                  top: 5, left: 5,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(Icons.more_vert_rounded,
                        size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Dot Pattern Painter (placeholder texture)
// ════════════════════════════════════════════════════════════════════════════

class _DotPatternPainter extends CustomPainter {
  const _DotPatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.09)
      ..style = PaintingStyle.fill;
    const spacing = 14.0;
    const radius  = 1.8;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter old) => old.color != color;
}

// ════════════════════════════════════════════════════════════════════════════
//  Full Screen Viewer  (pinch-to-zoom + swipe between photos)
// ════════════════════════════════════════════════════════════════════════════

class _FullScreenViewer extends StatefulWidget {
  const _FullScreenViewer({
    required this.photos,
    required this.initialIndex,
  });
  final List<_DesignPhoto> photos;
  final int                initialIndex;

  @override
  State<_FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<_FullScreenViewer> {
  late int            _current;
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _current  = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  _DesignPhoto get _photo => widget.photos[_current];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _photo.label.replaceAll('\n', ' '),
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Text(
              '${_current + 1} of ${widget.photos.length}',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11, color: Colors.white60),
            ),
          ],
        ),
        actions: [
          // Tag badge
          if (_photo.tag.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _photo.accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_photo.tag,
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        itemCount: widget.photos.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) => _ZoomablePage(photo: widget.photos[i]),
      ),
      // Bottom dot indicator
      bottomNavigationBar: widget.photos.length > 1
          ? Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _current ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _current
                          ? AppColors.primaryLight
                          : Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

// ── Single zoomable page ───────────────────────────────────────────────────

class _ZoomablePage extends StatelessWidget {
  const _ZoomablePage({required this.photo});
  final _DesignPhoto photo;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 4.5,
      boundaryMargin: EdgeInsets.zero,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
          child: AspectRatio(
            aspectRatio: 0.72,
            child: Container(
              decoration: BoxDecoration(
                color: photo.bgColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: photo.accentColor.withValues(alpha: 0.45),
                    width: 2),
                boxShadow: [
                  BoxShadow(
                    color: photo.accentColor.withValues(alpha: 0.35),
                    blurRadius: 48,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                        painter:
                            _DotPatternPainter(color: photo.accentColor)),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(photo.icon,
                              size: 86,
                              color: photo.accentColor
                                  .withValues(alpha: 0.70)),
                          const SizedBox(height: 22),
                          Text(
                            photo.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: photo.accentColor,
                              height: 1.3,
                            ),
                          ),
                          if (photo.tag.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: photo.accentColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(photo.tag,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pinch_rounded,
                                  size: 14,
                                  color: photo.accentColor
                                      .withValues(alpha: 0.55)),
                              const SizedBox(width: 5),
                              Text('Pinch to zoom  ·  Swipe to browse',
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 11,
                                      color: photo.accentColor
                                          .withValues(alpha: 0.55))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Preview Screen  (shown after choosing photo source)
// ════════════════════════════════════════════════════════════════════════════

class _PreviewScreen extends StatefulWidget {
  const _PreviewScreen({
    required this.id,
    required this.bgColor,
    required this.accentColor,
    required this.icon,
    required this.source,
    required this.tabName,
  });
  final int      id;
  final Color    bgColor;
  final Color    accentColor;
  final IconData icon;
  final String   source;
  final String   tabName;

  @override
  State<_PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<_PreviewScreen> {
  final _labelCtrl = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  void _addToGallery() {
    final raw   = _labelCtrl.text.trim();
    final label = raw.isEmpty ? 'New ${widget.tabName} Design' : raw;
    Navigator.pop(
      context,
      _DesignPhoto(
        id:          widget.id,
        label:       label,
        bgColor:     widget.bgColor,
        accentColor: widget.accentColor,
        icon:        widget.icon,
        tag:         widget.tabName,
      ),
    );
  }

  void _retake() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: _retake,
                  ),
                  Expanded(
                    child: Text(
                      'Preview  ·  ${widget.source}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  // Source badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.50)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.source == 'Camera'
                              ? Icons.camera_alt_rounded
                              : Icons.photo_library_rounded,
                          size: 12,
                          color: widget.accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(widget.source,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.accentColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Preview placeholder ────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.45),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.30),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomPaint(
                            painter: _DotPatternPainter(
                                color: widget.accentColor)),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.icon,
                                  size: 72,
                                  color: widget.accentColor
                                      .withValues(alpha: 0.75)),
                              const SizedBox(height: 18),
                              Text(
                                'New ${widget.tabName} Design',
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: widget.accentColor),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.source == 'Camera'
                                        ? Icons.camera_alt_rounded
                                        : Icons.photo_library_rounded,
                                    size: 14,
                                    color: widget.accentColor
                                        .withValues(alpha: 0.60),
                                  ),
                                  const SizedBox(width: 5),
                                  Text('from ${widget.source}',
                                      style: TextStyle(fontFamily: 'Poppins', 
                                          fontSize: 13,
                                          color: widget.accentColor
                                              .withValues(alpha: 0.60))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom panel: label + buttons ──────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 18 + bottomPad),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design Label',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _labelCtrl,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'e.g. Silk Blouse Round Neck…',
                      hintStyle: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 13, color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Retake
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _retake,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: Text('Retake',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.border),
                            minimumSize: Size.zero,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Add
                      Expanded(
                        flex: 2,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              AppColors.topbarStart,
                              AppColors.topbarEnd,
                            ]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _addToGallery,
                            icon: const Icon(Icons.add_rounded,
                                size: 18, color: Colors.white),
                            label: Text('Add to Gallery',
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize:
                                  const Size(double.infinity, 0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ════════════════════════════════════════════════════════════════════════════
//  Action Sheet  (Take Photo / Choose from Gallery)
// ════════════════════════════════════════════════════════════════════════════

class _ActionSheet extends StatelessWidget {
  const _ActionSheet({
    required this.onTakePhoto,
    required this.onChooseGallery,
  });
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Add Design Photo',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 18),
          // Take Photo
          _SheetOption(
            icon: Icons.camera_alt_rounded,
            title: 'Take Photo',
            subtitle: 'Use camera to capture the design',
            iconBg: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            onTap: onTakePhoto,
          ),
          const SizedBox(height: 10),
          // Choose from Gallery
          _SheetOption(
            icon: Icons.photo_library_rounded,
            title: 'Choose from Gallery',
            subtitle: 'Pick an existing photo from device',
            iconBg: const Color(0xFFF3E5F5),
            iconColor: const Color(0xFF7B1FA2),
            onTap: onChooseGallery,
          ),
          const SizedBox(height: 16),
          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: AppColors.surface2,
              ),
              child: Text('Cancel',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
  final IconData icon;
  final String   title;
  final String   subtitle;
  final Color    iconBg;
  final Color    iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

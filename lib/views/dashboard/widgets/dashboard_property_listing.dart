import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PropertyItem {
  const PropertyItem({
    required this.title,
    required this.price,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.imagePath,
    this.isNew = false,
  });

  final String title;
  final String price;
  final int beds;
  final int baths;
  final int sqft;
  final String imagePath;
  final bool isNew;
}

const List<PropertyItem> dummyProperties = [
  PropertyItem(
    title: 'Astra Heights',
    price: '₹1.25 Cr',
    beds: 4,
    baths: 3,
    sqft: 3200,
    imagePath: 'assets/image/home2.jpeg',
    isNew: true,
  ),

  PropertyItem(
    title: 'Ocean Breeze Villa',
    price: '₹98 Lakhs',
    beds: 3,
    baths: 2,
    sqft: 2400,
    imagePath: 'assets/image/home1.jpg',
  ),

  PropertyItem(
    title: 'Palm Grove Residency',
    price: '₹74 Lakhs',
    beds: 3,
    baths: 2,
    sqft: 2100,
    imagePath: 'assets/image/home3.jpg',
  ),

  PropertyItem(
    title: 'Skyline Grand',
    price: '₹1.48 Cr',
    beds: 5,
    baths: 4,
    sqft: 3800,
    imagePath: 'assets/image/home5.jpg',
    isNew: true,
  ),

  PropertyItem(
    title: 'Maplewood Estate',
    price: '₹86 Lakhs',
    beds: 4,
    baths: 3,
    sqft: 2900,
    imagePath: 'assets/image/home6.jpg',
  ),
];

class DashboardListingSection extends StatefulWidget {
  const DashboardListingSection({super.key});

  @override
  State<DashboardListingSection> createState() =>
      _DashboardListingSectionState();
}

class _DashboardListingSectionState extends State<DashboardListingSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  int _selectedCategory = 0;
  final List<String> _categories = const [
    'Recommended',
    'For Sale',
    'For Rent',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Stats cards row ----
            const _StatsRow(),

            const SizedBox(height: 22),

            // ---- Category chips ----
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == _selectedCategory;
                  return _CategoryChip(
                    label: _categories[index],
                    selected: selected,
                    onTap: () => setState(() => _selectedCategory = index),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby Properties',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---- Horizontal property list ----
            SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 4),
                itemCount: dummyProperties.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return _PropertyCard(item: dummyProperties[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  static const _stats = [
    (
      icon: Icons.people_rounded,
      label: 'Users',
      value: '128',
      color: Color(0xFF2E7D4F),
    ),
    (
      icon: Icons.favorite_rounded,
      label: 'Saved',
      value: '12',
      color: Color(0xFFE85D75),
    ),
    (
      icon: Icons.event_available_rounded,
      label: 'Visits',
      value: '3',
      color: Color(0xFFE59A22),
    ),
    (
      icon: Icons.chat_bubble_rounded,
      label: 'Messages',
      value: '5',
      color: Color(0xFF3B82F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_stats.length, (index) {
        final stat = _stats[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _stats.length - 1 ? 0 : 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Background
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: stat.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(stat.icon, size: 20, color: stat.color),
                  ),

                  const SizedBox(height: 9),

                  // Value
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D2A32),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Label
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary1 : const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _PropertyCard extends StatefulWidget {
  const _PropertyCard({required this.item});

  final PropertyItem item;

  @override
  State<_PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<_PropertyCard> {
  double _scale = 1.0;
  bool _isFavorite = false;

  void _showFullImage(BuildContext context, PropertyItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),

        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: FullImagePreview(
              imagePath: item.imagePath,
              title: item.title,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.97;
        });
      },

      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
      },

      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },

      /// OPEN FULL IMAGE
      onTap: () {
        _showFullImage(context, item);
      },

      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),

        child: Container(
          width: 230,
          height: 310,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),

            child: Stack(
              fit: StackFit.expand,
              children: [
                // =====================================================
                // PROPERTY IMAGE
                // =====================================================
                Hero(
                  tag: 'property_${item.imagePath}',

                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,

                        child: Icon(
                          Icons.home_work_outlined,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),

                // =====================================================
                // LIGHT WHITE FADE
                // =====================================================
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,

                        // Fade starts earlier
                        Color(0x26FFFFFF),

                        Color(0x66FFFFFF),

                        Color(0xB3FFFFFF),

                        Color(0xE6FFFFFF),

                        Colors.white,
                      ],
                      stops: [0.0, 0.32, 0.40, 0.55, 0.70, 1.0],
                    ),
                  ),
                ),

                // =====================================================
                // TOP BADGES
                // =====================================================
                Positioned(
                  top: 14,
                  left: 14,

                  child: Row(
                    children: [
                      /// Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: Color(0xFFFFB300),
                            ),

                            SizedBox(width: 4),

                            Text(
                              '4.9',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D2A32),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                // =====================================================
                // FAVORITE BUTTON
                // =====================================================
                Positioned(
                  top: 12,
                  right: 12,

                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },

                    child: Container(
                      width: 38,
                      height: 38,

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                      ),

                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),

                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },

                        child: Icon(
                          _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,

                          key: ValueKey(_isFavorite),

                          size: 19,

                          color: _isFavorite
                              ? Colors.redAccent
                              : const Color(0xFF1D2A32),
                        ),
                      ),
                    ),
                  ),
                ),

                // =====================================================
                // PROPERTY DETAILS
                // =====================================================
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        item.title,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D2A32),
                        ),
                      ),

                      const SizedBox(height: 7),

                      /// Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Colors.grey.shade800,
                          ),
                          const SizedBox(width: 6),

                          Text(
                            'Madurai, TN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Divider(height: 1, color: Colors.grey.shade300),

                      const SizedBox(height: 4),

                      /// Price
                      Text(
                        item.price,

                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Specs
                      Row(
                        children: [
                          _buildSpec(Icons.bed_outlined, '${item.beds} '),

                          const SizedBox(width: 12),

                          _buildSpec(Icons.bathtub_outlined, '${item.baths} '),

                          const SizedBox(width: 12),

                          _buildSpec(Icons.square_foot, '${item.sqft} sqft'),
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
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Icon(icon, size: 15, color: Colors.grey.shade600),

        const SizedBox(width: 4),

        Text(
          text,

          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

// ======================================================================
// FULL SCREEN IMAGE PREVIEW
// ======================================================================

class FullImagePreview extends StatelessWidget {
  const FullImagePreview({
    super.key,
    required this.imagePath,
    required this.title,
  });

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            // =========================================================
            // FULL SCREEN IMAGE
            // =========================================================
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,

                child: Hero(
                  tag: 'property_$imagePath',

                  child: Image.asset(
                    imagePath,

                    width: double.infinity,
                    height: double.infinity,

                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white,
                          size: 60,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // =========================================================
            // TOP HEADER
            // =========================================================
            Positioned(
              top: 12,
              left: 16,
              right: 16,

              child: Row(
                children: [
                  /// BACK BUTTON
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,

                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  /// TITLE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: Text(
                        title,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  /// CLOSE BUTTON
                  _CircleButton(
                    icon: Icons.close_rounded,

                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // =========================================================
            // BOTTOM HINT
            // =========================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,

              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: const Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.zoom_in_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),

                      SizedBox(width: 6),

                      Text(
                        'Pinch to zoom',

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// REUSABLE CIRCLE BUTTON
// ======================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 44,
        height: 44,

        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),

        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

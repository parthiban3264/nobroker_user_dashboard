import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final PageController _pageController = PageController();
  Timer? _autoTimer;
  int _currentPage = 0;

  static const List<_Promo> _promos = [
    _Promo(
      emoji: '🎉',
      title: 'Zero Brokerage Fee this month',
      subtitle: 'Save up to ₹50,000 on your next home',
      colors: [Color(0xFF2E7D4F), Color(0xFF16302A)],
    ),
    _Promo(
      emoji: '🏠',
      title: 'First 3 property visits FREE',
      subtitle: 'Exclusive for new users this week',
      colors: [Color(0xFF2F73C9), Color(0xFF10202D)],
    ),
    _Promo(
      emoji: '⚡',
      title: 'Refer a friend, get ₹500',
      subtitle: 'Cashback credited instantly on signup',
      colors: [Color(0xFFC9822F), Color(0xFF3A2410)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % _promos.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promos.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _PromoCard(promo: _promos[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (index) {
            final active = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.primary1 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _Promo {
  const _Promo({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colors,
  });
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> colors;
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo});
  final _Promo promo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: promo.colors),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(promo.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promo.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════
/// 2. TRUST STATS ROW — animated count-up numbers
/// ═══════════════════════════════════════════════════════════════════
class TrustStatsRow extends StatelessWidget {
  const TrustStatsRow({super.key});

  static const List<_Stat> _stats = [
    _Stat(target: 50000, suffix: '+', label: 'Properties'),
    _Stat(target: 10000, suffix: '+', label: 'Happy Users'),
    _Stat(target: 48, suffix: '', label: 'Rating', isDecimalRating: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_stats.length, (index) {
        final stat = _stats[index];
        return Expanded(
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: stat.target.toDouble()),
                duration: Duration(milliseconds: 900 + index * 150),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final display = stat.isDecimalRating
                      ? (value / 10).toStringAsFixed(1)
                      : value.round().toString();
                  return Text(
                    '$display${stat.suffix}${stat.isDecimalRating ? "⭐" : ""}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Stat {
  const _Stat({
    required this.target,
    required this.suffix,
    required this.label,
    this.isDecimalRating = false,
  });
  final int target;
  final String suffix;
  final String label;
  final bool isDecimalRating;
}

/// ═══════════════════════════════════════════════════════════════════
/// 3. EXPLORE BY CITY — 2x2 grid with image cards + tap-scale
/// ═══════════════════════════════════════════════════════════════════
class ExploreByCityGrid extends StatelessWidget {
  const ExploreByCityGrid({super.key, this.onCityTap});

  final ValueChanged<String>? onCityTap;

  static const List<_City> _cities = [
    _City(name: 'Chennai', imagePath: 'assets/image/city_chennai.png'),
    _City(name: 'Bangalore', imagePath: 'assets/image/city_bangalore.png'),
    _City(name: 'Mumbai', imagePath: 'assets/image/city_mumbai.png'),
    _City(name: 'Hyderabad', imagePath: 'assets/image/city_hyderabad.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final city = _cities[index];
        return _CityCard(city: city, onTap: () => onCityTap?.call(city.name));
      },
    );
  }
}

class _City {
  const _City({required this.name, required this.imagePath});
  final String name;
  final String imagePath;
}

class _CityCard extends StatefulWidget {
  const _CityCard({required this.city, this.onTap});
  final _City city;
  final VoidCallback? onTap;

  @override
  State<_CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<_CityCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.city.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary1.withValues(alpha: 0.15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 10,
                child: Text(
                  widget.city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

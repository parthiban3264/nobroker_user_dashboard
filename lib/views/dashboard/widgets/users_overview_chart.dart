import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ChartPeriod { week, month, year }

class UsersOverviewChart extends StatefulWidget {
  final List<FlSpot> weekData;
  final List<FlSpot> monthData;
  final List<FlSpot> yearData;

  const UsersOverviewChart({
    super.key,
    required this.weekData,
    required this.monthData,
    required this.yearData,
  });

  @override
  State<UsersOverviewChart> createState() => _UsersOverviewChartState();
}

class _UsersOverviewChartState extends State<UsersOverviewChart> {
  ChartPeriod _selectedPeriod = ChartPeriod.month;

  static const Color _primaryColor = Color(0xFF2E7D4F);
  static const Color _textColor = Color(0xFF1D2A32);

  List<FlSpot> get _currentData {
    switch (_selectedPeriod) {
      case ChartPeriod.week:
        return widget.weekData;

      case ChartPeriod.month:
        return widget.monthData;

      case ChartPeriod.year:
        return widget.yearData;
    }
  }

  String get _periodLabel {
    switch (_selectedPeriod) {
      case ChartPeriod.week:
        return 'This Week';

      case ChartPeriod.month:
        return 'This Month';

      case ChartPeriod.year:
        return 'This Year';
    }
  }

  double get _maxX {
    switch (_selectedPeriod) {
      case ChartPeriod.week:
        return 6;

      case ChartPeriod.month:
        return 30;

      case ChartPeriod.year:
        return 11;
    }
  }

  double get _maxY {
    if (_currentData.isEmpty) return 10;

    final maxValue = _currentData
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);

    return ((maxValue / 10).ceil() * 10 + 10).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        /// Better subtle border
        border: Border.all(color: const Color(0xFFE8ECEA), width: 1),

        /// Very subtle professional shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: _maxX,
                minY: 0,
                maxY: _maxY,

                clipData: const FlClipData.all(),

                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} Users',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE9EEEB),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),

                borderData: FlBorderData(show: false),

                titlesData: _buildTitles(),

                lineBarsData: [
                  LineChartBarData(
                    spots: _currentData,

                    isCurved: true,
                    curveSmoothness: 0.25,

                    color: _primaryColor,
                    barWidth: 2.5,

                    isStrokeCapRound: true,

                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: _primaryColor,
                        );
                      },
                    ),

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _primaryColor.withValues(alpha: 0.18),
                          _primaryColor.withValues(alpha: 0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),

            SizedBox(height: 3),

            Text(
              'User growth analytics',
              style: TextStyle(fontSize: 11, color: Color(0xFF7A8580)),
            ),
          ],
        ),

        const Spacer(),

        PopupMenuButton<ChartPeriod>(
          onSelected: (period) {
            setState(() {
              _selectedPeriod = period;
            });
          },
          offset: const Offset(0, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) {
            return [
              _buildMenuItem(ChartPeriod.week, 'This Week'),
              _buildMenuItem(ChartPeriod.month, 'This Month'),
              _buildMenuItem(ChartPeriod.year, 'This Year'),
            ];
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8E4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _periodLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 17,
                  color: Color(0xFF64706A),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<ChartPeriod> _buildMenuItem(ChartPeriod period, String title) {
    final isSelected = _selectedPeriod == period;

    return PopupMenuItem<ChartPeriod>(
      value: period,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 2),

      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF1D2A32)
                      : const Color(0xFF4B5651),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: _maxY / 4,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: Color(0xFF8A9490)),
            );
          },
        ),
      ),

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: _bottomTitleWidget,
        ),
      ),
    );
  }

  Widget _bottomTitleWidget(double value, TitleMeta meta) {
    String text = '';

    switch (_selectedPeriod) {
      case ChartPeriod.week:
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        if (value >= 0 && value < days.length) {
          text = days[value.toInt()];
        }
        break;

      case ChartPeriod.month:
        if (value == 0) text = 'May 1';
        if (value == 10) text = 'May 10';
        if (value == 20) text = 'May 20';
        if (value == 30) text = 'May 30';
        break;

      case ChartPeriod.year:
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        if (value >= 0 && value < months.length) {
          text = months[value.toInt()];
        }
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Color(0xFF8A9490)),
        ),
      ),
    );
  }
}

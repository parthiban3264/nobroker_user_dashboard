import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:noBroker_user_dashboard/core/constants/app_colors.dart';
import 'package:noBroker_user_dashboard/core/widgets/stats_card.dart';
import 'package:noBroker_user_dashboard/view_models/auth/auth_event.dart';

import 'package:noBroker_user_dashboard/view_models/user/user_bloc.dart';
import 'package:noBroker_user_dashboard/view_models/user/user_event.dart';
import 'package:noBroker_user_dashboard/view_models/user/user_state.dart';

import 'package:noBroker_user_dashboard/views/dashboard/widgets/dashboard_banners.dart';
import 'package:noBroker_user_dashboard/views/dashboard/widgets/dashboard_header.dart';
import 'package:noBroker_user_dashboard/views/dashboard/widgets/dashboard_property_listing.dart';
import 'package:noBroker_user_dashboard/views/dashboard/widgets/dashboard_search.dart';
import 'package:noBroker_user_dashboard/views/dashboard/widgets/dashboard_trust_section.dart';

import '../../app/routes.dart';
import '../../core/storage/flutter_secure_storage.dart';
import '../../core/widgets/custom_loading.dart';
import '../../view_models/auth/auth_bloc.dart';
import '../../view_models/auth/auth_state.dart';
import 'widgets/users_overview_chart.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late Future<Map<String, dynamic>?> _userFuture;
  @override
  void initState() {
    super.initState();

    _userFuture = TokenStorage.getUser();

    Future.microtask(() {
      context.read<UserBloc>().add(GetAllUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            /// ================= AUTH LISTENER =================
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                }

                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.msg),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ],

          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              int totalUsers = 0;
              int activeUsers = 0;
              int inactiveUsers = 0;

              /// ================= REAL USER DATA =================
              if (state is UserSuccess) {
                totalUsers = state.users.length;

                activeUsers = state.users
                    .where((user) => user.status == true)
                    .length;

                inactiveUsers = state.users
                    .where((user) => user.status != true)
                    .length;
              }

              final activePercentage = totalUsers == 0
                  ? 0.0
                  : (activeUsers / totalUsers) * 100;

              final inactivePercentage = totalUsers == 0
                  ? 0.0
                  : (inactiveUsers / totalUsers) * 100;

              final stats = [
                {
                  'title': 'Total Users',
                  'value': totalUsers.toString(),
                  'icon': Icons.groups_outlined,
                  'iconColor': const Color(0xFF2E7D4F),
                  'percentage': 'Total',
                  'isIncrease': true,
                  'chartData': <double>[
                    0,
                    totalUsers * 0.3,
                    totalUsers * 0.5,
                    totalUsers * 0.7,
                    totalUsers.toDouble(),
                  ],
                },
                {
                  'title': 'Active Users',
                  'value': activeUsers.toString(),
                  'icon': Icons.person_outline,
                  'iconColor': const Color(0xFF2F73C9),
                  'percentage': '${activePercentage.toStringAsFixed(1)}%',
                  'isIncrease': true,
                  'chartData': <double>[
                    0,
                    activeUsers * 0.3,
                    activeUsers * 0.6,
                    activeUsers.toDouble(),
                  ],
                },
                {
                  'title': 'Inactive',
                  'value': inactiveUsers.toString(),
                  'icon': Icons.person_off_outlined,
                  'iconColor': const Color(0xFFE52256),
                  'percentage': '${inactivePercentage.toStringAsFixed(1)}%',
                  'isIncrease': false,
                  'chartData': <double>[
                    0,
                    inactiveUsers * 0.4,
                    inactiveUsers * 0.7,
                    inactiveUsers.toDouble(),
                  ],
                },
                {
                  'title': 'Active Rate',
                  'value': '${activePercentage.toStringAsFixed(0)}%',
                  'icon': Icons.analytics_outlined,
                  'iconColor': const Color(0xFFE59A22),
                  'percentage': 'Live',
                  'isIncrease': activePercentage >= 50,
                  'chartData': <double>[
                    0,
                    activePercentage * 0.4,
                    activePercentage * 0.7,
                    activePercentage,
                  ],
                },
              ];

              return RefreshIndicator(
                color: AppColors.primary1,

                onRefresh: () async {
                  context.read<UserBloc>().add(GetAllUser());

                  await Future.delayed(const Duration(milliseconds: 500));
                },

                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),

                  slivers: [
                    /// ================= HEADER =================
                    SliverToBoxAdapter(
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: _userFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: CustomLoading()),
                            );
                          }

                          final user = snapshot.data;

                          return DashboardHeader(
                            userName: user?['name']?.toString() ?? 'User',
                            email: user?['email']?.toString() ?? '',
                            phone: user?['phone']?.toString() ?? '',
                            location: 'Tiruchendur, Tamil Nadu',

                            hasUnreadNotifications: true,

                            onNotificationTap: () {},

                            onLogout: () {
                              context.read<AuthBloc>().add(LogoutRequested());
                            },

                            onViewProfile: () {},
                          );
                        },
                      ),
                    ),

                    /// ================= SEARCH =================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: DashboardSearchBar(),
                      ),
                    ),

                    /// ================= BANNER =================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: PromoBannerCarousel(),
                      ),
                    ),

                    /// ================= OVERVIEW =================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Overview',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1D2A32),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Track your users and activity',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF7A8580),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary1.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: AppColors.primary1,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// ================= PROPERTY =================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DashboardListingSection(),
                      ),
                    ),

                    /// ================= STATS TITLE =================
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 22, 20, 12),
                        child: Text(
                          'User Statistics',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A32),
                          ),
                        ),
                      ),
                    ),

                    /// ================= USER LOADING =================
                    if (state is UserLoading)
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),

                    /// ================= REAL USER STATS =================
                    if (state is UserSuccess)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 180,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: stats.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = stats[index];

                              return SizedBox(
                                width: 170,
                                child: StatsCard(
                                  title: item['title'] as String,
                                  value: item['value'] as String,
                                  icon: item['icon'] as IconData,
                                  iconColor: item['iconColor'] as Color,
                                  percentage: item['percentage'] as String,
                                  isIncrease: item['isIncrease'] as bool,
                                  chartData: item['chartData'] as List<double>,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    /// ================= USER ERROR =================
                    if (state is UserError)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 45,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 10),
                                Text(state.msg, textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<UserBloc>().add(GetAllUser());
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    /// ================= CHART =================
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                        child: Text(
                          'Users Overview',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A32),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6EBE8)),
                        ),
                        child: UsersOverviewChart(
                          weekData: [
                            FlSpot(0, totalUsers.toDouble()),
                            FlSpot(1, activeUsers.toDouble()),
                            FlSpot(2, inactiveUsers.toDouble()),
                          ],

                          monthData: [
                            FlSpot(0, totalUsers.toDouble()),
                            FlSpot(1, activeUsers.toDouble()),
                            FlSpot(2, inactiveUsers.toDouble()),
                          ],

                          yearData: [
                            FlSpot(0, totalUsers.toDouble()),
                            FlSpot(1, activeUsers.toDouble()),
                            FlSpot(2, inactiveUsers.toDouble()),
                          ],
                        ),
                      ),
                    ),

                    /// ================= SUMMARY =================
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary1,
                              const Color(0xFF102A29),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 38,
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$activeUsers active users',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    '$totalUsers total users • '
                                    '${activePercentage.toStringAsFixed(1)}% currently active',
                                    style: const TextStyle(
                                      color: Color(0xFFD9E5E0),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DashboardTrustSection(onChatTap: () {}),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

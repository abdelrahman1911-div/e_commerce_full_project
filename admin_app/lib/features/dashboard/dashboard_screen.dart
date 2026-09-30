import 'dart:async';
import 'dart:developer';
import 'package:e_commerce_admin/core/di/injection_container.dart';
import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/cubit/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final DashboardCubit _dashboardCubit;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _dashboardCubit = dashboardCubit;

    _dashboardCubit.getDashboardStats();

    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;

      log('Timer refresh started');

      _dashboardCubit.getDashboardStats();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _dashboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 60),
                      const SizedBox(height: 16),
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          log('Try Again refresh started');
                          context.read<DashboardCubit>().getDashboardStats();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is DashboardSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  log('Pull to refresh started');
                  await context.read<DashboardCubit>().getDashboardStats();
                },
                child: _DashboardContent(
                  totalOrders: state.totalOrders,
                  totalProducts: state.totalProducts,
                  totalUsers: state.totalUsers,
                  totalCategories: state.totalCategories,
                  totalBrands: state.totalBrands,
                  totalDrivers: state.totalDrivers,
                ),
              );
            }
            if (state is DashboardRefreshing) {
              return RefreshIndicator(
                onRefresh: () async {
                  log('Pull to refresh while refreshing');

                  await context.read<DashboardCubit>().getDashboardStats();
                },
                child: _DashboardContent(
                  totalOrders: state.totalOrders,
                  totalProducts: state.totalProducts,
                  totalUsers: state.totalUsers,
                  totalCategories: state.totalCategories,
                  totalBrands: state.totalBrands,
                  totalDrivers: state.totalDrivers,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final int totalOrders;
  final int totalProducts;
  final int totalUsers;
  final int totalCategories;
  final int totalBrands;
  final int totalDrivers;
  const _DashboardContent({
    required this.totalOrders,
    required this.totalProducts,
    required this.totalUsers,
    required this.totalCategories,
    required this.totalBrands,
    required this.totalDrivers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1000;
        final isDesktop = width >= 1000;
        final int crossAxisCount;
        if (isMobile) {
          crossAxisCount = 2;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 5;
        }
        final horizontalPadding = isMobile
            ? 16.0
            : isTablet
            ? 24.0
            : 40.0;
        final titleSize = isMobile ? 22.0 : 28.0;
        final subtitleSize = isMobile ? 13.0 : 15.0;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here is an overview of your store.',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isMobile
                          ? 1.05
                          : isTablet
                          ? 1.10
                          : isDesktop
                          ? 1.15
                          : 1.10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return DashboardStatCard(
                            title: 'Total Orders',
                            value: totalOrders,
                            icon: Icons.shopping_bag_outlined,
                            onTap: () {
                              context.push(AppRoutes.orders);
                            },
                          );
                        case 1:
                          return DashboardStatCard(
                            title: 'Total Products',
                            value: totalProducts,
                            icon: Icons.inventory_2_outlined,
                            onTap: () {
                              context.push(AppRoutes.products);
                            },
                          );
                        case 2:
                          return DashboardStatCard(
                            title: 'Total Users',
                            value: totalUsers,
                            icon: Icons.people_outline,
                            onTap: () {
                              context.push(AppRoutes.users);
                            },
                          );
                        case 3:
                          return DashboardStatCard(
                            title: 'Total Categories',
                            value: totalCategories,
                            icon: Icons.category_outlined,
                            onTap: () {
                              context.push(AppRoutes.categories);
                            },
                          );
                        case 4:
                          return DashboardStatCard(
                            title: 'Total Brands',
                            value: totalBrands,
                            icon: Icons.branding_watermark_sharp,
                            onTap: () {
                              context.push(AppRoutes.brands);
                            },
                          );
                        case 5:
                          return DashboardStatCard(
                            title: "Total Drivers",
                            value: totalDrivers,
                            icon: Icons.motorcycle_outlined,
                            onTap: () {
                              context.push(AppRoutes.drivers);
                            },
                          );
                        default:
                          return DashboardStatCard(
                            title: 'Total Brands',
                            value: totalBrands,
                            icon: Icons.branding_watermark_outlined,
                            onTap: () {
                              context.push(AppRoutes.brands);
                            },
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 180;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: compact ? 42 : 48,
                    height: compact ? 42 : 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, size: compact ? 22 : 25),
                  ),
                  const Spacer(),
                  Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: compact ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 12 : 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: compact ? 12 : 14,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

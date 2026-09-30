import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardRefreshing extends DashboardState {
  final int totalOrders;
  final int totalProducts;
  final int totalUsers;
  final int totalCategories;
  final int totalBrands; 
  final int totalDrivers; 
  const DashboardRefreshing({
    required this.totalOrders,
    required this.totalProducts,
    required this.totalUsers,
    required this.totalCategories,
    required this.totalBrands, 
    required this.totalDrivers
  });
  @override
  List<Object?> get props => [
        totalOrders,
        totalProducts,
        totalUsers,
        totalCategories,
        totalBrands, 
        totalDrivers
      ];
}
class DashboardSuccess extends DashboardState {
  final int totalOrders;
  final int totalProducts;
  final int totalUsers;
  final int totalCategories;
  final int totalBrands;
  final int totalDrivers;


  const DashboardSuccess({
    required this.totalOrders,
    required this.totalProducts,
    required this.totalUsers,
    required this.totalCategories,
    required this.totalBrands, 
    required this.totalDrivers, 
  });

  @override
  List<Object?> get props => [
        totalOrders,
        totalProducts,
        totalUsers,
        totalCategories,
        totalBrands, 
        totalDrivers, 
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
import 'package:e_commerce_admin/features/dashboard/dashboard_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;
  DashboardCubit(this._dashboardRepository) : super(DashboardInitial());
 Future<void> getDashboardStats() async {
  final currentState = state;

  if (currentState is! DashboardSuccess) {
    emit(DashboardLoading());
  }

  try {
    final stats = await _dashboardRepository.getDashboardStats();

    emit(
      DashboardSuccess(
        totalOrders: stats.totalOrders,
        totalProducts: stats.totalProducts,
        totalUsers: stats.totalUsers,
        totalCategories: stats.totalCategories,
        totalBrands: stats.totalBrands, 
        totalDrivers: stats.totalDrivers
      ),
    );
  } catch (e) {
    if (currentState is DashboardSuccess) {
      return;
    }

    emit(
      DashboardError(
        message: e.toString(),
      ),
    );
  }
}
}

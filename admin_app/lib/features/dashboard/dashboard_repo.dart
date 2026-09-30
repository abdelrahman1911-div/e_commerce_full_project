import 'package:cloud_firestore/cloud_firestore.dart';
class DashboardStats {
  final int totalOrders;
  final int totalProducts;
  final int totalUsers;
  final int totalCategories;
  final int totalBrands; 
  final int totalDrivers; 
  const DashboardStats({
    required this.totalOrders,
    required this.totalProducts,
    required this.totalUsers,
    required this.totalCategories,
    required this.totalBrands, 
    required this.totalDrivers
  });
}
abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();
}
class DashboardRepositoryImpl
    implements DashboardRepository {
  final FirebaseFirestore _firestore;
  DashboardRepositoryImpl(this._firestore);
 @override
Future<DashboardStats> getDashboardStats() async {
  final results = await Future.wait([
    _getCollectionCount('products'),
    _getCollectionCount('users'),
    _getCollectionCount('drivers'),
    _getCollectionCount('categories'),
    _getCollectionCount('brands'),
    _getOrdersCount(),
  ]);

  final totalUsers = results[1] + results[2];

  return DashboardStats(
    totalProducts: results[0],
    totalUsers: totalUsers,
    totalCategories: results[3],
    totalBrands: results[4],
    totalOrders: results[5],
    totalDrivers: results[2],
  );
}
  Future<int> _getCollectionCount(
    String collectionName,
  ) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
  Future<int> _getOrdersCount() async {
    final snapshot = await _firestore
        .collectionGroup('orders')
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
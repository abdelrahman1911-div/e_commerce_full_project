import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
abstract class SearchState {
  const SearchState();
}
class SearchInitial extends SearchState {}
class SearchLoaded extends SearchState {
  final List<ProductModel> products;
  final bool isSearching;
  const SearchLoaded({
    required this.products,
    required this.isSearching,
  });
}
class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  List<ProductModel> _allProducts = [];
  List<BrandModel> _allBrands = [];
  void initialize({
    required List<ProductModel> products,
    required List<BrandModel> brands,
  }) {
    _allProducts = products;
    _allBrands = brands;
    emit(
      SearchLoaded(
        products: products,
        isSearching: false,
      ),
    );
  }
  void search(String query) {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      emit(
        SearchLoaded(
          products: _allProducts,
          isSearching: false,
        ),
      );
      return;
    }
    final matchingBrandIds = _allBrands
        .where(
          (brand) =>
              brand.name.toLowerCase().contains(searchQuery),
        )
        .map((brand) => brand.id)
        .toSet();
    final filteredProducts = _allProducts.where((product) {
      final productName =
          product.name.toLowerCase();

      final description =
          product.description.toLowerCase();

      final matchesProductName =
          productName.contains(searchQuery);

      final matchesDescription =
          description.contains(searchQuery);

      final matchesBrand =
          matchingBrandIds.contains(product.brandId);

      return matchesProductName ||
          matchesDescription ||
          matchesBrand;
    }).toList();
    emit(
      SearchLoaded(
        products: filteredProducts,
        isSearching: true,
      ),
    );
  }
  void clearSearch() {
    emit(
      SearchLoaded(
        products: _allProducts,
        isSearching: false,
      ),
    );
  }
}

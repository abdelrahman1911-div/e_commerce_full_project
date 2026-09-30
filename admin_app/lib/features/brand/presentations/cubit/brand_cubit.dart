import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:e_commerce_admin/features/brand/data/repos/brands_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  final BrandRepository _repository;

  BrandCubit(this._repository)
      : super(BrandInitial());

  Future<void> getAllBrands() async {
    emit(BrandLoading());

    try {
      final brands =
          await _repository.getAllBrands();

      emit(
        BrandSuccess(brands),
      );
    } catch (e) {
      emit(
        BrandError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> createBrand(
    AdminBrandModel brand,
  ) async {
    final currentBrands =
        _getCurrentBrands();

    emit(
      BrandSaving(
        currentBrands,
      ),
    );

    try {
      await _repository.createBrand(
        brand,
      );

      await getAllBrands();
    } catch (e) {
      emit(
        BrandError(
          e.toString(),
        ),
      );

      emit(
        BrandSuccess(
          currentBrands,
        ),
      );
    }
  }

  Future<void> updateBrand(
    AdminBrandModel brand,
  ) async {
    final currentBrands =
        _getCurrentBrands();

    emit(
      BrandSaving(
        currentBrands,
      ),
    );

    try {
      await _repository.updateBrand(
        brand,
      );

      await getAllBrands();
    } catch (e) {
      emit(
        BrandError(
          e.toString(),
        ),
      );

      emit(
        BrandSuccess(
          currentBrands,
        ),
      );
    }
  }

  Future<void> deleteBrand(
    String brandId,
  ) async {
    final currentBrands =
        _getCurrentBrands();

    emit(
      BrandDeleting(
        brands: currentBrands,
        brandId: brandId,
      ),
    );

    try {
      await _repository.deleteBrand(
        brandId,
      );

      await getAllBrands();
    } catch (e) {
      emit(
        BrandError(
          e.toString(),
        ),
      );

      emit(
        BrandSuccess(
          currentBrands,
        ),
      );
    }
  }

  List<AdminBrandModel>
      _getCurrentBrands() {
    final currentState = state;

    if (currentState
        is BrandSuccess) {
      return currentState.brands;
    }

    if (currentState
        is BrandSaving) {
      return currentState.brands;
    }

    if (currentState
        is BrandDeleting) {
      return currentState.brands;
    }

    return [];
  }
}
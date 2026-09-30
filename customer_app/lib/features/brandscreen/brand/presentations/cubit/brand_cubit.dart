import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/domain/repos/brands_repo.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandCubit extends Cubit<BrandState> {
  final BrandRepository _brandRepository;

  BrandCubit(this._brandRepository) : super(BrandInitial());

  Future<void> getAllBrands() async {
    emit(BrandLoading());

    try {
      final brands = await _brandRepository.getAllBrands();
      emit(BrandSuccess(brands));
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }

  Future<void> getBrandById(String brandId) async {
    emit(BrandLoading());

    try {
      final brand = await _brandRepository.getBrandById(brandId);

      if (brand == null) {
        emit(const BrandError('brand_not_found'));
        return;
      }

      emit(BrandByIdSuccess(brand));
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }

  Future<void> addBrand(BrandModel brand) async {
    emit(BrandLoading());

    try {
      await _brandRepository.addBrand(brand);
      emit(BrandOperationSuccess());
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }

  Future<void> updateBrand(BrandModel brand) async {
    emit(BrandLoading());

    try {
      await _brandRepository.updateBrand(brand);
      emit(BrandOperationSuccess());
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }

  Future<void> deleteBrand(String brandId) async {
    emit(BrandLoading());

    try {
      await _brandRepository.deleteBrand(brandId);
      emit(BrandOperationSuccess());
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }
}
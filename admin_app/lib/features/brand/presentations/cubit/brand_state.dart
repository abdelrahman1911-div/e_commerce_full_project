import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';


abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandSuccess extends BrandState {
  final List<AdminBrandModel> brands;

  const BrandSuccess(this.brands);

  @override
  List<Object?> get props => [brands];
}

class BrandSaving extends BrandState {
  final List<AdminBrandModel> brands;

  const BrandSaving(this.brands);

  @override
  List<Object?> get props => [brands];
}

class BrandDeleting extends BrandState {
  final List<AdminBrandModel> brands;
  final String brandId;

  const BrandDeleting({
    required this.brands,
    required this.brandId,
  });

  @override
  List<Object?> get props => [
        brands,
        brandId,
      ];
}

class BrandError extends BrandState {
  final String message;

  const BrandError(this.message);

  @override
  List<Object?> get props => [message];
}
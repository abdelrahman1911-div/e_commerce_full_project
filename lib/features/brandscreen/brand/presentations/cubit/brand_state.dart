import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class BrandState extends Equatable {
 const BrandState();
 @override List<Object?> get props => []; 
} 
class BrandInitial extends BrandState {} 
class BrandLoading extends BrandState {} 
class BrandSuccess extends BrandState {
  final List<BrandModel> brands ; 
  const BrandSuccess(this.brands); 
  @override 
  List<Object?> get props => [brands];
} 
class BrandByIdSuccess extends BrandState {
  final BrandModel brand ; 
  const BrandByIdSuccess(this.brand); 
  @override 
  List<Object?> get props => [brand];

} 
class BrandOperationSuccess extends BrandState {} 
class BrandError extends BrandState {
 final String message;
 const BrandError(this.message);
  @override 
  List<Object?> get props => [message]; }
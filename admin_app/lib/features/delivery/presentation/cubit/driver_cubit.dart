import 'package:e_commerce_admin/features/delivery/data/model/Admin_driver_model.dart';
import 'package:e_commerce_admin/features/delivery/domain/driver_repo.dart';
import 'package:e_commerce_admin/features/delivery/presentation/cubit/states/driver_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository _driverRepository;

  DriverCubit(this._driverRepository) : super(DriverInitial());

  Future<void> getAvailableDrivers() async {
    emit(DriverLoading());

    try {
      final List<AdminDriverModel> drivers =
          await _driverRepository.getAvailableDrivers();

      emit(DriverSuccess(drivers));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }
}
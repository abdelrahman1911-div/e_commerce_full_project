import 'package:e_commerce_admin/features/delivery/presentation/cubit/driver_cubit.dart';
import 'package:e_commerce_admin/features/delivery/presentation/cubit/states/driver_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverTestScreen extends StatefulWidget {
  const DriverTestScreen({super.key});

  @override
  State<DriverTestScreen> createState() => _DriverTestScreenState();
}

class _DriverTestScreenState extends State<DriverTestScreen> {
  @override
  void initState() {
    super.initState();

    context.read<DriverCubit>().getAvailableDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Test'),
      ),
      body: BlocBuilder<DriverCubit, DriverState>(
        builder: (context, state) {
          if (state is DriverLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DriverError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is DriverSuccess) {
            return ListView.builder(
              itemCount: state.drivers.length,
              itemBuilder: (context, index) {
                final driver = state.drivers[index];

                return ListTile(
                  title: Text(driver.driverName),
                  subtitle: Text(driver.email),
                  trailing: Text(
                    '${driver.isOnline} / ${driver.isAvailable}',
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
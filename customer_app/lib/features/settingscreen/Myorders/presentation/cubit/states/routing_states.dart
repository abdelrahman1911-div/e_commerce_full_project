import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';

abstract class RoutingState {
  const RoutingState();
}

class RoutingInitial extends RoutingState {
  const RoutingInitial();
}

class RoutingLoading extends RoutingState {
  const RoutingLoading();
}

class RoutingSuccess extends RoutingState {
  final RouteModel route;

  const RoutingSuccess(this.route);
}

class RoutingError extends RoutingState {
  final String message;

  const RoutingError(this.message);
}

class OrderStatus {
  static const String pending = 'pending';

  static const String placed = 'placed';

  static const String shipping = 'shipping';

  static const String backInTransit = 'back_in_transit';

  static const String arriveToday = 'arrive_today';

  static const String delivered = 'delivered';

  static const String cancelled = 'cancelled';

  static const List<String> values = [
    pending,
    placed,
    shipping,
    backInTransit,
    arriveToday,
    delivered,
    cancelled,
  ];

  static String label(String status) {
    switch (status) {
      case pending:
        return 'Pending';

      case placed:
        return 'Placed';

      case shipping:
        return 'Shipping';

      case backInTransit:
        return 'Back in Transit';

      case arriveToday:
        return 'Arrive Today';

      case delivered:
        return 'Delivered';

      case cancelled:
        return 'Cancelled';

      default:
        return status;
    }
  }
}

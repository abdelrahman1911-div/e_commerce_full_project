import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/tracking_step_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingWidget extends StatefulWidget {
  final String orderid;
  final double? width;
  final EdgeInsetsGeometry? padd;
  final Color? color;
  final BorderRadius? br;
  final String? headerText;
  final String? trackingStep1;
  final String? trackingStep2;
  final String? trackingStep3;

  const TrackingWidget({
    super.key,
    required this.orderid,
    this.width,
    this.padd,
    this.color,
    this.br,
    this.headerText,
    this.trackingStep1,
    this.trackingStep2,
    this.trackingStep3,
  });

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrderModel? order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  // ============================================================
  // FORMAT ADDRESS
  // ============================================================

  String _formatAddress(String address) {
    if (address.trim().isEmpty) {
      return address;
    }

    String formattedAddress = address.trim();
    final plusCodeRegex = RegExp(
      r'^[A-Z0-9]{4,8}\+[A-Z0-9]{2,4},?\s*',
      caseSensitive: false,
    );

    formattedAddress = formattedAddress.replaceFirst(plusCodeRegex, '');


    formattedAddress = formattedAddress.replaceAll(
      RegExp(r'(,\s*Egypt)+', caseSensitive: false),
      ', Egypt',
    );
    formattedAddress = formattedAddress.replaceAll(RegExp(r'\s+'), ' ');
    formattedAddress = formattedAddress.replaceAll(RegExp(r',\s*,+'), ',');
    formattedAddress = formattedAddress.replaceFirst(RegExp(r',\s*$'), '');
    return formattedAddress.trim();
  }


  Future<void> getOrder() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = 'User is not authenticated';
        });

        return;
      }

      final userId = currentUser.uid;

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(widget.orderid)
          .get();

      if (!doc.exists) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = 'Order not found';
        });

        return;
      }

      final data = doc.data();

      if (data == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = 'Order data is empty';
        });

        return;
      }

      final selectedOrder = OrderModel.fromJson(data);

      if (!mounted) return;

      setState(() {
        order = selectedOrder;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('GET ORDER ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // ACTIVE STEP
  // ============================================================

  int get activeStep {
    switch (order?.status.toLowerCase()) {
      case 'pending':
        return 0;

      case 'shipped':
        return 1;

      case 'in_transit':
      case 'in transit':
        return 2;

      case 'delivered':
        return 3;

      default:
        return 0;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    if (isLoading) {
      return Container(
        width: widget.width ?? double.infinity,
        padding: widget.padd ?? EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: widget.color ?? (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: widget.br ?? BorderRadius.circular(16.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || order == null) {
      return Container(
        width: widget.width ?? double.infinity,
        padding: widget.padd ?? EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: widget.color ?? (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: widget.br ?? BorderRadius.circular(16.r),
        ),
        child: Text(
          errorMessage ?? 'Order not found',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    // ==========================================================
    // FORMATTED ADDRESS
    // ==========================================================

    final String formattedAddress = _formatAddress(order!.address);

    return Container(
      width: widget.width ?? double.infinity,
      padding: widget.padd ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.color ?? (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: widget.br ?? BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),

          // =====================================================
          // HEADER
          // =====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.headerText ?? 'order_tracking.deliver_to'.tr(),
                style: theme.textTheme.titleMedium,
              ),

              SizedBox(width: 20.w),

              Expanded(
                child: Text(
                  formattedAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // =====================================================
          // STEP 1
          // =====================================================
          TrackingStep(
            title:
                widget.trackingStep1 ?? 'order_tracking.package_shipped'.tr(),
            isActive: activeStep >= 1,
            isLast: false,
          ),

          // =====================================================
          // STEP 2
          // =====================================================
          TrackingStep(
            title: widget.trackingStep2 ?? 'order_tracking.in_transit'.tr(),
            isActive: activeStep >= 2,
            isLast: false,
          ),

          // =====================================================
          // STEP 3
          // =====================================================
          TrackingStep(
            title: widget.trackingStep3 ?? 'order_tracking.arriving_today'.tr(),
            isActive: activeStep >= 3,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

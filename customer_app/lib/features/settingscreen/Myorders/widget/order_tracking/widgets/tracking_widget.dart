import 'dart:async';
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

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _orderSubscription;

  OrderModel? order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _watchOrder();
  }

  void _watchOrder() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'User is not authenticated';
      });
      return;
    }
    _orderSubscription = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('orders')
        .doc(widget.orderid)
        .snapshots()
        .listen(
      (doc) {
        if (!doc.exists) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
            errorMessage = 'Order not found';
            order = null;
          });
          return;
        }
        final data = doc.data();
        if (data == null) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
            errorMessage = 'Order data is empty';
            order = null;
          });
          return;
        }
        final selectedOrder = OrderModel.fromJson(data);
        if (!mounted) return;
        setState(() {
          order = selectedOrder;
          isLoading = false;
          errorMessage = null;
        });
      },
      onError: (error) {
        debugPrint('ORDER TRACKING ERROR: $error');
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = error.toString();
        });
      },
    );
  }
  String _formatAddress(String address) {
    if (address.trim().isEmpty) {
      return address;
    }
    String formattedAddress = address.trim();
    final plusCodeRegex = RegExp(
      r'^[A-Z0-9]{4,8}\+[A-Z0-9]{2,4},?\s*',
      caseSensitive: false,
    );
    formattedAddress = formattedAddress.replaceFirst(
      plusCodeRegex,
      '',
    );
    formattedAddress = formattedAddress.replaceAll(
      RegExp(
        r'(,\s*Egypt)+',
        caseSensitive: false,
      ),
      ', Egypt',
    );
    formattedAddress = formattedAddress.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    formattedAddress = formattedAddress.replaceAll(
      RegExp(r',\s*,+'),
      ',',
    );
    formattedAddress = formattedAddress.replaceFirst(
      RegExp(r',\s*$'),
      '',
    );
    return formattedAddress.trim();
  }

  int get activeStep {

    switch (order?.status.toLowerCase()) {

      case 'placed':

        return 2;


      case 'assigned':

      case 'accepted':

      case 'picked_up':

        return 3;

      case 'on_the_way':
        return 4;

      case 'delivered':
        return 5;

      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isLoading) {

      return Container(

        width: widget.width ?? double.infinity,

        padding: widget.padd ?? EdgeInsets.all(16.w),

        decoration: BoxDecoration(

          color: widget.color ??

              (isDark ? Colors.grey[900] : Colors.white),

          borderRadius: widget.br ?? BorderRadius.circular(16.r),

        ),

        child: const Center(

          child: CircularProgressIndicator(),

        ),

      );

    }

    if (errorMessage != null || order == null) {

      return Container(

        width: widget.width ?? double.infinity,

        padding: widget.padd ?? EdgeInsets.all(16.w),

        decoration: BoxDecoration(

          color: widget.color ??

              (isDark ? Colors.grey[900] : Colors.white),

          borderRadius: widget.br ?? BorderRadius.circular(16.r),
        ),
        child: Text(
         
          errorMessage ?? 'Order not found',
         
          style: theme.textTheme.bodyMedium,
        
        ),
      
      );
    
    }
    final formattedAddress = _formatAddress(order!.address);
    return Container(
      width: widget.width ?? double.infinity,
      padding: widget.padd ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.color ??
            (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: widget.br ?? BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.headerText ??
                    'order_tracking.deliver_to'.tr(),
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

          TrackingStep(
            title: widget.trackingStep1 ??
                'order_tracking.package_placed'.tr(),
            isActive: activeStep >= 0,
            isLast: false,
          ),

          TrackingStep(
            title: widget.trackingStep2 ??
                'order_tracking_confirmed'.tr(),
            isActive: activeStep >= 1,
            isLast: false,
          ),

          TrackingStep(
            title: widget.trackingStep3 ??
                'order_tracking_Preparing'.tr(),
            isActive: activeStep >= 2,
            isLast: false,
          ),

          TrackingStep(
            title: 'order_tracking.picked_up'.tr(),
            isActive: activeStep >= 3,
            isLast: false,
          ),

          TrackingStep(
            title: 'order_tracking.on_the_way'.tr(),
            isActive: activeStep >= 4,
            isLast: false,
          ),

          TrackingStep(
            title: 'order_tracking.delivered'.tr(),
            isActive: activeStep >= 5,
            isLast: true,
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }
}
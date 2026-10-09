import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/milestone_app_6_cart_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/state/milestone_app_6_auth_store.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';

import '../methods/order_details_screen_logic.dart';

class MilestoneApp6OrderDetailsScreen extends StatefulWidget {
  final MilestoneApp6State state;
  final MilestoneApp6AuthStore auth;
  final List<MilestoneApp6CartItem> items;
  final String paymentType;
  final double subtotal;
  final double shipping;
  final double discount;
  final double totalPayment;
  final double minimumPayment;
  final double amountPaidNow;
  final String? orderId;

  const MilestoneApp6OrderDetailsScreen({
    super.key,
    required this.state,
    required this.auth,
    required this.items,
    required this.paymentType,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.totalPayment,
    required this.minimumPayment,
    required this.amountPaidNow,
    this.orderId,
  });

  @override
  State<MilestoneApp6OrderDetailsScreen> createState() =>
      _MilestoneApp6OrderDetailsScreenState();
}

class _MilestoneApp6OrderDetailsScreenState
    extends State<MilestoneApp6OrderDetailsScreen>
    with OrderDetailsScreenLogic {}

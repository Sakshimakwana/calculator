import 'package:flutter/material.dart';

class AddressWidgetsLoading extends StatelessWidget {
  const AddressWidgetsLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 50,
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
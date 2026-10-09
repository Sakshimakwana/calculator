import 'package:flutter/material.dart';

class MilestoneApp6ReviewsHeader extends StatelessWidget {
  const MilestoneApp6ReviewsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Reviews',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 10),

        Text(
          'All your restaurant reviews and ratings in one place.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff777777),
          ),
        ),

        SizedBox(height: 30),
      ],
    );
  }
}
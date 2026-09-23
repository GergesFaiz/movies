import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class MainErrorWidget extends StatelessWidget {
  String massage;
  VoidCallback onPressed;

  MainErrorWidget({super.key, required this.massage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(massage, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(
              "try again",
              style: Theme
                  .of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                color: Theme
                    .of(context)
                    .primaryColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

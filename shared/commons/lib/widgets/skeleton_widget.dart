import 'package:commons/colors/app_colors.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:flutter/material.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(baseColor: AppColors.kGrey, highlightColor: AppColors.kLightGrey, child: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(5),
      ),
    ));
  }
}
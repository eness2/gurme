import 'package:flutter/material.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:gurme/common/constants/color_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LoadingAnimationWidget.beat(
          color: ColorConstants.primaryColor,
          size: width + 25,
        ),
        Image.asset(
          AssetConstants.shortLogoPurpleLoading,
          width: width,
          height: height,
        ),
        // Loading spinner
      ],
    );
  }
}

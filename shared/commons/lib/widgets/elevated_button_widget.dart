import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        fixedSize: MaterialStateProperty.all(const Size.fromHeight(50)),
        backgroundColor: MaterialStateProperty.all(AppColors.kWhite),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      //style: ElevatedButton.styleFrom(
      //  splashFactory: NoSplash.splashFactory,
      //  fixedSize: const Size.fromHeight(50),
      //  backgroundColor: AppColors.kWhite,
      //  elevation: 0,
      //  shape: RoundedRectangleBorder(
      //    borderRadius: BorderRadius.circular(10),
      //  ),
      //),
      child: Text(
        text,
        style: AppTextTheme.kTitle3(
            color: AppColors.kBlack, fontWeight: FontWeight.w500),
      ),
    );
  }
}

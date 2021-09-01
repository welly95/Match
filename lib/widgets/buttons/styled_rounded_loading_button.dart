import 'package:flutter/material.dart';
import 'package:modon_screens/constants/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class StyledRoundedLoadingButton extends StatelessWidget {
  final String label;
  final RoundedLoadingButtonController buttonController;
  final void Function()? onPressed;
  final double? width;
  final Color? color;
  final Color? successColor;
  final Color? labelColor;

  StyledRoundedLoadingButton({
    required this.label,
    required this.buttonController,
    required this.onPressed,
    this.width,
    this.color,
    this.successColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      width: width ?? MediaQuery.of(context).size.width * 0.85,
      borderRadius: 3.0,
      color: color ?? Colors.black,
      successColor: successColor ?? Colors.black,
      controller: buttonController,
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyles.buttonLabel.copyWith(color: labelColor ?? Colors.white),
      ),
    );
  }
}

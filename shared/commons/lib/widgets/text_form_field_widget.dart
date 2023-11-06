import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget(
      {super.key,
      this.inputFormatters,
      this.keyboardType,
      required this.labelText,
      required this.controller,
      this.isPassword = false,
      this.maxLines = 1,
      this.border,
      this.width});

  final String labelText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final InputBorder? border;
  final int? maxLines;
  final bool isPassword;
  final double? width;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool? obscureText;
  InputBorder? border;

  Size get _size => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;

    if (widget.border == null) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColors.kWhite,
        ),
      );
    } else {
      border = widget.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? _size.width * 0.5,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        maxLines: widget.maxLines,
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        obscureText: obscureText!,
        style: AppTextTheme.kBody1(
            color: AppColors.kBlack, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: AppTextTheme.kBody1(
              color: AppColors.kBlack, fontWeight: FontWeight.normal),
          fillColor: AppColors.kWhite,
          filled: true,
          hoverColor: Colors.transparent,
          enabledBorder: border,
          focusedBorder: border,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText!;
                    });
                  },
                  icon: Icon(
                    obscureText! ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.kBlack,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

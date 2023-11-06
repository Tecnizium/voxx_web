import 'package:commons/colors/app_colors.dart';
import 'package:commons/text_theme/app_text_theme.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateFormFieldWidget extends StatefulWidget {
  const DateFormFieldWidget(
      {super.key, required this.labelText, required this.controller});

  final String labelText;
  final TextEditingController controller;

  @override
  State<DateFormFieldWidget> createState() => _DateFormFieldWidgetState();
}

class _DateFormFieldWidgetState extends State<DateFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        await showDatePicker(
                context: context,
                initialDate: widget.controller.text.isEmpty
                    ? DateTime.now()
                    : DateTime(
                        int.parse(widget.controller.text.split('/')[2]),
                        int.parse(widget.controller.text.split('/')[1]),
                        int.parse(widget.controller.text.split('/')[0])),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)))
            .then((value) {
          if (value != null) {
            widget.controller.text = DateFormat('dd/MM/yyyy').format(value);
          }
        });
      },
      controller: widget.controller,
      style: AppTextTheme.kBody1(
          color: AppColors.kBlack, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        labelText: widget.labelText,
        labelStyle: AppTextTheme.kBody1(
            color: AppColors.kBlack, fontWeight: FontWeight.normal),
        fillColor: AppColors.kWhite,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.kWhite,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.kWhite,
          ),
        ),
      ),
    );
  }
}

import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:flutter/material.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key, this.question});
  final QuestionModel? question;

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  Size get _size => MediaQuery.of(context).size;
  QuestionModel? question;
  TextEditingController _textController = TextEditingController();
  List<TextEditingController> _optionsController = [];

  @override
  void initState() {
    if (widget.question != null) {
      question = widget.question;
      _textController.text = question!.text!;
    } else {
      question = QuestionModel();
      question!.options = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: _size.width,
        height: _size.height,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(20),
          width: _size.width * 0.5,
          height: _size.height * 0.7,
          decoration: BoxDecoration(
              color: AppColors.kLightBlue3,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(
                  widget.question == null ? 'Create Question' : 'Edit Question',
                  style: AppTextTheme.kTitle3(
                      color: AppColors.kBlack, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldWidget(
                maxLines: 2,
                labelText: 'Text',
                controller: _textController,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Options',
                    style: AppTextTheme.kBody1(color: AppColors.kBlack),
                  ),
                  ElevatedButtonWidget(
                      text: 'Add option',
                      onPressed: () {
                        setState(() {
                          if (_optionsController.isEmpty ||
                              _optionsController.last.text.isNotEmpty) {
                            if (question!.options!.isNotEmpty) {
                              question!.options!.last.text =
                                  _optionsController.last.text;
                            }

                            question!.options!.add(OptionModel());
                            _optionsController = [];
                          }
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: question?.options?.length ?? 0,
                    itemBuilder: (context, index) {
                      TextEditingController _optionController =
                          TextEditingController(
                              text: question!.options![index].text);
                      _optionsController.add(_optionController);
              
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormFieldWidget(
                            labelText: 'Option ${index + 1}',
                            controller: _optionController,
                          ),
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButtonWidget(
                      text: widget.question != null ? 'Delete' : 'Cancel',
                      onPressed: () => context.pop(null)),
                  ElevatedButtonWidget(
                      text: widget.question != null ? 'Save' : 'Create',
                      onPressed: () {
                        if (_textController.text.isEmpty) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          SnackBarWidget.errorSnackBar(
                              context, 'Text is required');
                        } else if (question!.options!.length < 2) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          SnackBarWidget.errorSnackBar(
                              context, 'At least 2 options are required');
                        } else if (_optionsController
                            .any((element) => element.text.isEmpty)) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          SnackBarWidget.errorSnackBar(
                              context, 'All options must be filled');
                        } else {
                          question!.text = _textController.text;
                          question!.options = [];
                          _optionsController.forEach((element) {
                            if (element.text.isNotEmpty) {
                              question!.options!
                                  .add(OptionModel(text: element.text));
                            }
                          });
                          context.pop(question!);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

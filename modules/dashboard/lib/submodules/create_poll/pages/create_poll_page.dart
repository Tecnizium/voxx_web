import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:dashboard/submodules/create_poll/pages/create_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../dashboard/bloc/dashboard_bloc.dart';
import '../bloc/create_poll_bloc.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage({super.key, this.poll});
  final PollModel? poll;

  @override
  State<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  Size get _size => MediaQuery.of(context).size;
  PollModel? poll;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _campaignIdController = TextEditingController();

  @override
  void initState() {
    debugPrint('CreatePollPage: $widget');

    poll = widget.poll;
    if (poll != null) {
      _titleController.text = poll!.title!;
      _descriptionController.text = poll!.description!;
      _startDateController.text =
          DateFormat('dd/MM/yyyy').format(poll!.startDate!);
      _endDateController.text = DateFormat('dd/MM/yyyy').format(poll!.endDate!);
      _campaignIdController.text = poll!.campaignId!;
    } else {
      poll = PollModel(questions: []);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePollBloc, CreatePollState>(
      bloc: context.read<CreatePollBloc>(),
      listener: (context, state) {
        debugPrint('CreatePollState: $state');
        switch (state.runtimeType) {
          case CreatePollLoading:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.loadingSnackBar(context);
            break;
          case CreatePollSuccess:
            context.pop();
            context.pop(true);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.successSnackBar(context, 'Create poll success');
            break;
          case EditPollSuccess:
            context.pop();    
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.successSnackBar(context, 'Edit poll success');
            context.pop(true);
            break;
          case CreatePollError:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.errorSnackBar(
                context, (state as CreatePollError).message);
            break;
          case DeletePollSuccess:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.successSnackBar(context, 'Delete poll success');
            context.pop(true);
            break;
          case CancelPollSuccess:
            context.pop(false);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.kLightBlue3,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              backgroundColor: AppColors.kBlue,
              centerTitle: false,
              title: Row(
                children: [
                  Text(
                    'VOXX',
                    style: AppTextTheme.kTitle1(color: AppColors.kWhite),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _size.width * 0.5,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.poll == null ? 'Create Poll' : 'Edit Poll',
                              style:
                                  AppTextTheme.kTitle3(color: AppColors.kBlack),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormFieldWidget(
                            labelText: 'Title', controller: _titleController),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: _size.width * 0.1,
                                child: DateFormFieldWidget(
                                    labelText: 'Start Date',
                                    controller: _startDateController)),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                                width: _size.width * 0.1,
                                child: DateFormFieldWidget(
                                    labelText: 'End Date',
                                    controller: _endDateController)),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                  labelText: 'Campaign Group',
                                  controller: _campaignIdController),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormFieldWidget(
                            maxLines: 3,
                            labelText: 'Description',
                            controller: _descriptionController),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Questions',
                              style:
                                  AppTextTheme.kTitle3(color: AppColors.kBlack),
                            ),
                            ElevatedButtonWidget(
                              text: 'Add question',
                              onPressed: () {
                                showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CreateQuestionPage())
                                    .then((value) => setState(() {
                                          if (value != null) {
                                            poll?.questions.add(value);
                                          }
                                        }));
                                //context.read<CreatePollBloc>().add(
                                //      AddQuestionButtonPressedEvent(),
                                //    );
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (poll?.questions.isEmpty ?? true)
                          Container(
                            alignment: Alignment.center,
                            width: _size.width * 0.5,
                            height: _size.height * 0.3,
                            decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'You don\'t have any questions yet',
                              style: AppTextTheme.kBody1(color: AppColors.kBlack),
                            ),
                          ) else Container(
                          decoration: BoxDecoration(
                              color: AppColors.kWhite,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: poll?.questions.length,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CreateQuestionPage(
                                                      question: poll
                                                          ?.questions[index]))
                                          .then((value) => setState(() {
                                                if (value != null) {
                                                  poll?.questions[index] =
                                                      value as QuestionModel;
                                                } else {
                                                  poll?.questions
                                                      .removeAt(index);
                                                }
                                              }));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: _size.width * 0.5,
                                          height: 75,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                poll?.questions[index].text ??
                                                    '',
                                                style: AppTextTheme.kBody1(
                                                    color: AppColors.kBlack),
                                              ),
                                              Icon(Icons.arrow_forward_ios)
                                            ],
                                          ),
                                        ),
                                        if (index != poll!.questions.length - 1)
                                          Divider(
                                              indent: 10,
                                              endIndent: 10,
                                              color: AppColors.kBlack,
                                              height: 1)
                                      ],
                                    ),
                                  )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButtonWidget(
                                text: widget.poll != null ? 'Delete' : 'Cancel',
                                onPressed: () => context.read<CreatePollBloc>().add(DeleteOrCancelPollButtonPressedEvent(poll: poll!))),
                            ElevatedButtonWidget(
                                text: widget.poll != null ? 'Save' : 'Create',
                                onPressed: () {
                                  if (_titleController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Title is required');
                                  } else if (_startDateController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Start Date is required');
                                  } else if (_endDateController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'End Date is required');
                                  } else if (_campaignIdController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Campaign Group is required');
                                  } else if (poll!.questions.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Questions is required');
                                  } else {
                                    poll!.title = _titleController.text;
                                    poll!.description =
                                        _descriptionController.text;
                                    poll!.startDate = DateFormat('dd/MM/yyyy')
                                        .parse(_startDateController.text);
                                    poll!.endDate = DateFormat('dd/MM/yyyy')
                                        .parse(_endDateController.text);
                                    poll!.campaignId =
                                        _campaignIdController.text;

                                    context.read<CreatePollBloc>().add(
                                          SaveOrCreatePollButtonPressedEvent(
                                              poll: poll!),
                                        );
                                  }

                                  //if(_textController.text.isEmpty){
                                  //  return showErrorDialog(context, 'Text is required');
                                  //}
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
      },
    );
  }
}

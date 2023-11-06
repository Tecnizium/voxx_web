import 'dart:math';

import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../bloc/details_poll_bloc.dart';

class DetailsPollPage extends StatefulWidget {
  const DetailsPollPage({super.key, this.poll});

  final PollModel? poll;

  @override
  State<DetailsPollPage> createState() => _DetailsPollPageState();
}

class _DetailsPollPageState extends State<DetailsPollPage> {
  Size get _size => MediaQuery.of(context).size;
  PollModel? poll;
  PollStatModel? pollStat;
  Map<String, Color>? colorMap = {};

  @override
  void initState() {
    poll = widget.poll;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsPollBloc, DetailsPollState>(
      bloc: context.read<DetailsPollBloc>(),
      listener: (context, state) {
        switch (state.runtimeType) {
          case DetailsPollLoaded:
            poll = (state as DetailsPollLoaded).poll;
            context.read<DetailsPollBloc>().add(
                  GetPollStatEvent(pollId: poll!.id!),
                );
            break;
          case PollStatLoaded:
            setState(() {
              pollStat = (state as PollStatLoaded).pollStat;

              pollStat?.pollPercentage?.forEach((key, value) {
                value.forEach((key2, value2) {
                  if (!colorMap!.containsKey(key2)) {
                    colorMap![key2] = getRandomColor();
                  }
                });
              });
            });
            break;
          case PollStatError:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.errorSnackBar(
                context, (state as PollStatError).message);
            break;
          case RedirectToEditPoll:
            context.goNamed(AppRoutesName.createPoll,
                extra: (state as RedirectToEditPoll).poll);
          default:
        }
      },
      builder: (context, state) {
        if (widget.poll == null && state is DetailsPollInitial) {
          context.read<DetailsPollBloc>().add(
                GetPollDetailsCachedEvent(),
              );
        } else {
          if (pollStat == null && state is DetailsPollInitial) {
            context.read<DetailsPollBloc>().add(
                  GetPollStatEvent(pollId: widget.poll!.id!),
                );
          }
        }

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
                      child: (state is DetailsPollLoaded ||
                              widget.poll != null ||
                              poll != null)
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      poll!.title!,
                                      style: AppTextTheme.kTitle3(
                                          color: AppColors.kBlack),
                                    ),
                                    ElevatedButtonWidget(
                                        text: 'Edit Poll',
                                        onPressed: () {
                                          context.read<DetailsPollBloc>().add(
                                              EditPollButtonPressedEvent(
                                                  poll: poll!));
                                        })
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: _size.width * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Start Date: ${DateFormat('dd/MM/yyyy').format(poll!.startDate!)}',
                                          style: AppTextTheme.kBody1(
                                              color: AppColors.kBlack)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'End Date: ${DateFormat('dd/MM/yyyy').format(poll!.endDate!)}',
                                          style: AppTextTheme.kBody1(
                                              color: AppColors.kBlack)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Campaign Group: ${poll!.campaignId}',
                                          style: AppTextTheme.kBody1(
                                              color: AppColors.kBlack)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Description: ${poll!.description}',
                                          textAlign: TextAlign.justify,
                                          style: AppTextTheme.kBody1(
                                              color: AppColors.kBlack)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (pollStat != null ||
                                          state is PollStatError)
                                        Text(
                                            'Total Answered: ${pollStat?.pollCount?['TotalAnswers']?['TotalAnswers'] ?? 0}',
                                            style: AppTextTheme.kBody1(
                                                color: AppColors.kBlack))
                                      else
                                        const SkeletonWidget(
                                            size: Size(160, 16))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Questions',
                                      style: AppTextTheme.kTitle3(
                                          color: AppColors.kBlack),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if (state is PollStatLoading)
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return ExpansionTileSkeletonWidget(
                                            size: _size);
                                      }),
                                if (state is PollStatLoaded ||
                                    state is PollStatError)
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: poll?.questions.length ?? 0,
                                      itemBuilder: (context, index) =>
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ExpansionTile(
                                                tilePadding:
                                                    const EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                collapsedShape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                collapsedBackgroundColor:
                                                    AppColors.kWhite,
                                                backgroundColor:
                                                    AppColors.kWhite,
                                                title: Text(
                                                  poll?.questions[index].text ??
                                                      '',
                                                  style: AppTextTheme.kBody1(
                                                      color: AppColors.kBlack),
                                                ),
                                                children: [
                                                  SizedBox(
                                                      width: 200,
                                                      height: 200,
                                                      child: (state
                                                              is PollStatLoaded)
                                                          ? PieChart(
                                                              PieChartData(
                                                                  sections: [
                                                                    for (var option
                                                                        in poll?.questions[index].options ??
                                                                            [])
                                                                      PieChartSectionData(
                                                                        color: colorMap![option.text.toString()] ??
                                                                            getRandomColor(),
                                                                        titleStyle:
                                                                            AppTextTheme.kBody2(color: getTextColor(colorMap![option.text.toString()] ?? getRandomColor())),
                                                                        title: pollStat?.pollCount?[poll?.questions[index].id]?[option.text.toString()].toString() ??
                                                                            '0',
                                                                        value:
                                                                            double.tryParse(pollStat?.pollPercentage?[poll?.questions[index].id]?[option.text.toString()].toString() ?? '0') ??
                                                                                0,
                                                                      ),
                                                                  ],
                                                                  sectionsSpace:
                                                                      0,
                                                                  centerSpaceRadius:
                                                                      50),
                                                            )
                                                          : Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'No data',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: AppTextTheme
                                                                  .kBody1(
                                                                      color:
                                                                          AppColors.kBlack)),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppColors
                                                                  .kLightGrey),
                                                            )),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: poll
                                                              ?.questions[index]
                                                              .options!
                                                              .length ??
                                                          0,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        String? option = poll
                                                            ?.questions[index]
                                                            .options![index2]
                                                            .text;

                                                        return ListTile(
                                                          leading: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: colorMap![
                                                                      option
                                                                          .toString()] ??
                                                                  getRandomColor(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            option ?? '',
                                                            style: AppTextTheme
                                                                .kBody2(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          trailing: Text(
                                                            "${NumberFormat('0.00').format(double.tryParse(pollStat?.pollPercentage?[poll?.questions[index].id]?[option.toString()].toString() ?? '0'))}%",
                                                            style: AppTextTheme
                                                                .kBody2(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      })
                                                ]),
                                          ))
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class ExpansionTileSkeletonWidget extends StatelessWidget {
  const ExpansionTileSkeletonWidget({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
          tilePadding: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          collapsedBackgroundColor: AppColors.kWhite,
          backgroundColor: AppColors.kWhite,
          title: SkeletonWidget(size: Size(size.width * 0.1, 16)),
          children: const [SizedBox()]),
    );
  }
}

//Generate Random Color
Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

//Generate Text Color
Color getTextColor(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

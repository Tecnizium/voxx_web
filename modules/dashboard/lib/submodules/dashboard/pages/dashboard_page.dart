import 'dart:html';

import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.user});

  final UserModel? user;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Size get _size => MediaQuery.of(context).size;
  UserModel? user;
  List<PollModel>? polls;

  @override
  void initState() {
    debugPrint('DashboardPage: ${widget.user}');
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: context.read<DashboardBloc>(),
      listener: (context, state) {
        debugPrint('DashboardState: $state');
        switch (state.runtimeType) {
          case DashboardLoaded:
            polls = (state as DashboardLoaded).polls;
            break;
          case DashboardError:
            SnackBarWidget.errorSnackBar(
                context, (state as DashboardError).message);
            break;
          case RedirectToCreatePoll:
            context.pushNamed(AppRoutesName.createPoll).then((value) => {
                  if (value as bool)
                    {context.read<DashboardBloc>().add(DashboardInitialEvent())}
                  else
                    {
                      context
                          .read<DashboardBloc>()
                          .add(DashboardLoadedEvent(polls: polls ?? []))
                    }
                });
            break;
          case RedirectToPollDetail:
            context.pushNamed(AppRoutesName.pollDetails,
                extra: (state as RedirectToPollDetail).poll).then((value) => {
                  if (value as bool)
                    {context.read<DashboardBloc>().add(DashboardInitialEvent())}
                  else
                    {
                      context
                          .read<DashboardBloc>()
                          .add(DashboardLoadedEvent(polls: polls ?? []))
                    }
                });
            break;
          case UserCacheLoaded:
            user = (state as UserCacheLoaded).user;
            break;
          default:
        }
      },
      builder: (context, state) {
        if (user == null && state is DashboardInitial) {
          context.read<DashboardBloc>().add(GetUserCachedEvent());
        }
        if (polls == null && state is DashboardInitial) {
          context.read<DashboardBloc>().add(DashboardInitialEvent());
        }
        return Scaffold(
            backgroundColor: AppColors.kLightBlue3,
            appBar: AppBar(
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
            body: Container(
              alignment: Alignment.topCenter,
              width: _size.width,
              height: _size.height,
              child: Container(
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
                          'Your Polls',
                          style: AppTextTheme.kTitle3(color: AppColors.kBlack),
                        ),
                        ElevatedButtonWidget(
                            text: 'Create Poll',
                            onPressed: () {
                              context.read<DashboardBloc>().add(
                                    CreatePollButtonPressedEvent(),
                                  );
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (state is DashboardLoading)
                      Expanded(
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return PollCardSkeletonWidget(size: _size);
                              })),
                    if (state is DashboardLoaded && polls!.isEmpty)
                      Expanded(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              'You don\'t have any polls yet',
                              style:
                                  AppTextTheme.kBody1(color: AppColors.kBlack),
                            ),
                          ),
                        ),
                      ),
                    if (state is DashboardLoaded ||
                        state is RedirectToPollDetail && polls!.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            itemCount: polls?.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () =>
                                      context.read<DashboardBloc>().add(
                                            RedirectToPollDetailEvent(
                                                poll: polls![index]),
                                          ),
                                  child: PollCardWidget(
                                    poll: polls![index],
                                    size: _size,
                                  ),
                                )),
                      )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

class PollCardWidget extends StatelessWidget {
  const PollCardWidget({super.key, required this.poll, required this.size});

  final Size size;
  final PollModel? poll;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.kWhite, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poll!.title ?? '',
                  style: AppTextTheme.kTitle3(color: AppColors.kBlack),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: poll!.description,
                      style: AppTextTheme.kBody2(color: AppColors.kBlack),
                    ))
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.arrow_forward_ios),
              Text(
                DateFormat('dd/MM/yyyy').format(poll!.endDate!).toString(),
                style: AppTextTheme.kBody3(color: AppColors.kBlack),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PollCardSkeletonWidget extends StatelessWidget {
  const PollCardSkeletonWidget({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.kWhite, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(size: Size(size.width * 0.2, 20)),
                //SizedBox(
                //  height: 20,
                //  width: size.width * 0.2,
                //  child: SkeletonWidget(),
                //),
                //Text(
                //  poll!.title ?? '',
                //  style: AppTextTheme.kTitle3(color: AppColors.kBlack),
                //  overflow: TextOverflow.ellipsis,
                //),
                const SizedBox(
                  height: 20,
                ),
                SkeletonWidget(size: Size(size.width * 0.4, 14)),
                const SizedBox(
                  height: 5,
                ),
                SkeletonWidget(size: Size(size.width * 0.4, 14)),
                const SizedBox(
                  height: 5,
                ),
                SkeletonWidget(size: Size(size.width * 0.2, 14)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Icon(Icons.arrow_forward_ios)),
              SkeletonWidget(size: Size(120, 12))
            ],
          )
        ],
      ),
    );
  }
}

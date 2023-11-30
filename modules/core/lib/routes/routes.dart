import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/core.dart';
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/submodules/details_poll/bloc/details_poll_bloc.dart';
import 'package:dashboard/submodules/details_poll/pages/details_poll_page.dart';
import 'package:flutter/material.dart';
import 'package:login/login.dart';

part 'routes_endpoints.dart';

abstract class AppRouter {
  static CustomTransitionPage<dynamic> customTransitionPage(
          {required BlocProvider child, required BuildContext context}){

      debugPrint('CurrentPage: ${child.child}');
      return CustomTransitionPage(
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero);}

  static GoRouter get router => GoRouter(
        routes: routes,
        errorBuilder: (context, state) => const Material(
          child: Center(
            child: Text('Page not found'),
          ),
        ),
      );

  static List<GoRoute> get routes => [home, dashboard];

  static GoRoute get home => GoRoute(
          path: AppRoutesPath.home,
          name: AppRoutesName.home,
          pageBuilder: (context, state) => customTransitionPage(
              child: BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(),
                child: const HomePage(),
              ),
              context: context),
          routes: [
            signIn,
            signUp,
          ]);
  static GoRoute get signIn => GoRoute(
      path: AppRoutesPath.signIn,
      name: AppRoutesName.signIn,
      pageBuilder: (context, state) => customTransitionPage(
          child: BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(),
            child: const SignInPage(),
          ),
          context: context));

  static GoRoute get signUp => GoRoute(
      path: AppRoutesPath.signUp,
      name: AppRoutesName.signUp,
      pageBuilder: (context, state) => customTransitionPage(
          child: BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(),
            child: const SignUpPage(),
          ),
          context: context));

  static GoRoute get dashboard => GoRoute(
      path: AppRoutesPath.dashboard,
      name: AppRoutesName.dashboard,
      routes: [createPoll, detailsPoll],
      pageBuilder: (context, state) => customTransitionPage(
          child: BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(),
            child: DashboardPage(
              user: state.extra is UserModel ? state.extra as UserModel : null,
            ),
          ),
          context: context));

  static GoRoute get createPoll => GoRoute(
      path: AppRoutesPath.createPoll,
      name: AppRoutesName.createPoll,
      pageBuilder: (context, state) {
        return customTransitionPage(
            child: BlocProvider<CreatePollBloc>(
              create: (context) => CreatePollBloc(),
              child: CreatePollPage(
                poll: state.extra as PollModel?,
              ),
            ),
            context: context);
      });
  static GoRoute get detailsPoll => GoRoute(
      path: AppRoutesPath.pollDetails,
      name: AppRoutesName.pollDetails,
      pageBuilder: (context, state) {
        return customTransitionPage(
            child: BlocProvider<DetailsPollBloc>(
              create: (context) => DetailsPollBloc(),
              child: DetailsPollPage(
                poll: state.extra as PollModel?,
              ),
            ),
            context: context);
      });
}

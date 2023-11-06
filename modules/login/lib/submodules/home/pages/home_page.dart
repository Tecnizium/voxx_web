import 'package:commons/colors/app_colors.dart';
import 'package:commons/commons.dart';
import 'package:commons/text_theme/app_text_theme.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/submodules/home/bloc/home_bloc.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case RedirectToSignIn:
            context.goNamed(AppRoutesName.signIn);
            break;
          case RedirectToSignUp:
            context.goNamed(AppRoutesName.signUp);
            break;
          default:
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
                right: 0,
                child:
                    SvgPicture.asset('assets/images/Circle_3_SIDE_BOTTEM.svg')),
            Positioned(
                left: 0,
                bottom: 0,
                child: SvgPicture.asset('assets/images/Circle_1_TOP.svg')),
            Positioned(
                left: 0,
                bottom: 0,
                child: SvgPicture.asset('assets/images/Circle_2_MID.svg')),
            Scaffold(
                backgroundColor: Colors.transparent,
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
                  actions: [
                    ElevatedButtonWidget(
                      text: 'Sign Up',
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeSignUpButtonPressed(),
                            );
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButtonWidget(
                      text: 'Sign In',
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeSignInButtonPressed(),
                            );
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                body: Center(
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.kBlue.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Welcome!',
                          style: AppTextTheme.customSize(
                              fontSize: 70, color: AppColors.kWhite))),
                )),
          ],
        );
      },
    );
  }
}

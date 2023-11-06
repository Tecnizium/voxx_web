import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login/submodules/sign_in/bloc/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case SignInLoading:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.loadingSnackBar(context);
            break;
          case SignInSuccess:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            context.goNamed(AppRoutesName.dashboard,
                extra: (state as SignInSuccess).user);
            break;
          case SignInError:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.errorSnackBar(
                context, (state as SignInError).message);
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
                body: Center(
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      width: 475,
                      height: 550,
                      decoration: BoxDecoration(
                        color: AppColors.kBlue.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 355,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    child: Text('Welcome',
                                        textAlign: TextAlign.center,
                                        style: AppTextTheme.customSize(
                                            fontSize: 64,
                                            color: AppColors.kWhite)),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Text('Back!',
                                        textAlign: TextAlign.center,
                                        style: AppTextTheme.customSize(
                                            fontSize: 64,
                                            color: AppColors.kWhite)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormFieldWidget(
                                labelText: 'Your Email',
                                controller: _emailController),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormFieldWidget(
                                labelText: 'Password',
                                controller: _passwordController,
                                isPassword: true),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Forgot Password?',
                                textAlign: TextAlign.center,
                                style: AppTextTheme.kBody1(
                                        color: AppColors.kWhite)
                                    .copyWith(
                                        decorationColor: AppColors.kWhite,
                                        decoration: TextDecoration.underline)),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButtonWidget(
                                text: 'SIGN IN',
                                onPressed: () {
                                  if (_emailController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Email is required');
                                  } else if (!emailValidator(
                                      _emailController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Email is invalid');
                                  } else if (_passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Password is required');
                                  } else if (!passwordValidator(
                                      _passwordController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Password is invalid');
                                  } else {
                                    context.read<SignInBloc>().add(
                                        SignInButtonPressed(
                                            email: _emailController.text,
                                            password:
                                                _passwordController.text));
                                  }
                                }),
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  context.goNamed(AppRoutesName.signUp),
                              child: Text('Don\'t have an account?',
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.kBody1(
                                          color: AppColors.kWhite)
                                      .copyWith(
                                          decorationColor: AppColors.kWhite,
                                          decoration:
                                              TextDecoration.underline)),
                            ),
                          ],
                        ),
                      )),
                )),
          ],
        );
      },
    );
  }
}

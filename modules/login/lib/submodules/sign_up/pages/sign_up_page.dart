import 'package:commons/commons.dart';
import 'package:commons_dependencies/commons_dependencies.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/submodules/sign_up/bloc/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case SignUpLoading:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.loadingSnackBar(context);
            break;
          case SignUpSuccess:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.successSnackBar(context, 'Sign up success');
            context.goNamed(AppRoutesName.signIn);
            break;
          case SignUpError:
            context.pop();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarWidget.errorSnackBar(
                context, (state as SignUpError).message);
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
                      height: 650,
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
                                    child: Text('Create an',
                                        textAlign: TextAlign.center,
                                        style: AppTextTheme.customSize(
                                            fontSize: 64,
                                            color: AppColors.kWhite)),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Text('Account!',
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFieldWidget(
                                      labelText: 'First Name',
                                      controller: _firstNameController),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormFieldWidget(
                                      labelText: 'Last Name',
                                      controller: _lastNameController),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormFieldWidget(
                              labelText: 'CPF/CNPJ',
                              controller: _usernameController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CpfOuCnpjFormatter()
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
                              height: 20,
                            ),
                            ElevatedButtonWidget(
                                text: 'SIGN UP',
                                onPressed: () {
                                  if (_firstNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'First Name is required');
                                  } else if (!nameValidator(
                                      _firstNameController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'First Name is invalid');
                                  } else if (_lastNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Last Name is required');
                                  } else if (!nameValidator(
                                      _lastNameController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'Last Name is invalid');
                                  } else if (_usernameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'CPF/CNPJ is required');
                                  } else if (!cpfValidator(
                                          _usernameController.text) ||
                                      !cnpjValidator(
                                          _usernameController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    SnackBarWidget.errorSnackBar(
                                        context, 'CPF/CNPJ is invalid');
                                  } else if (_emailController.text.isEmpty) {
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
                                    context
                                        .read<SignUpBloc>()
                                        .add(SignUpButtonPressed(
                                          username: _usernameController.text,
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ));
                                  }
                                }),
                            Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  context.goNamed(AppRoutesName.signIn),
                              child: Text('Already have an account?',
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

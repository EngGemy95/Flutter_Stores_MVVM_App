import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_app/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_app/presentation/resources_data/assets_manager.dart';
import 'package:advanced_app/presentation/resources_data/color_manager.dart';
import 'package:advanced_app/presentation/resources_data/routes_manager.dart';
import 'package:advanced_app/presentation/resources_data/strings_manager.dart';
import 'package:advanced_app/presentation/resources_data/styles_manager.dart';
import 'package:advanced_app/presentation/resources_data/values_managers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_prefs.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewmodel _loginViewmodel = instance<LoginViewmodel>();
  final AppPreference _appPreference = instance<AppPreference>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _loginViewmodel.start();
    _userNameController.addListener(
        () => _loginViewmodel.setUserName(_userNameController.text));
    _passwordController.addListener(
        () => _loginViewmodel.setpassword(_passwordController.text));

    _loginViewmodel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        // Navigate to main screen
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          _appPreference.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _loginViewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _loginViewmodel.outPutState,
          builder: ((context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _loginViewmodel.login();
                }) ??
                _getContentWidget();
          })),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.all(AppPadding.p5),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _loginViewmodel.outIsUserNameValid,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          hintText: AppStrings.userName,
                          labelText: AppStrings.userName,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.userNameError,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _loginViewmodel.outIspasswordValid,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.passwordError,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewmodel.outIsAreAllInputsValid,
                  builder: ((context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _loginViewmodel.login();
                              }
                            : null,
                        child: const Text(AppStrings.login),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.forgetPasswordRoute);
                        },
                        child: Text(AppStrings.forgetPassword,
                            textAlign: TextAlign.end,
                            style: getMediumStyle(
                                color: ColorManager.primary, fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.registerRoute);
                        },
                        child: Text(AppStrings.notAMemberSignUp,
                            textAlign: TextAlign.end,
                            style: getMediumStyle(
                                color: ColorManager.primary, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

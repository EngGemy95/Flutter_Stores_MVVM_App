import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_app/presentation/forget_password/viewmodel/forgetpassword_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../resources_data/assets_manager.dart';
import '../../resources_data/color_manager.dart';
import '../../resources_data/strings_manager.dart';
import '../../resources_data/values_managers.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final ForgetPasswordViewModel _forgetPasswordViewModel =
      instance<ForgetPasswordViewModel>();

  final _formKey = GlobalKey<FormState>();

  bind() {
    _forgetPasswordViewModel.start();
    _emailTextEditingController.addListener(() =>
        _forgetPasswordViewModel.setEmail(_emailTextEditingController.text));
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //_emailTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _forgetPasswordViewModel.outPutState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _forgetPasswordViewModel.forgetPassword();
                }) ??
                _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.only(top: AppPadding.p100),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(image: AssetImage(ImageAssets.splashLogo)),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _forgetPasswordViewModel.outputIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailHint,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.emailError),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _forgetPasswordViewModel.outputIsAllInputValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () => _forgetPasswordViewModel.forgetPassword()
                              : null,
                          child: const Text(AppStrings.resetPassword)),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

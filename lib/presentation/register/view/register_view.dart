import 'dart:io';

import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/app/constants.dart';
import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_app/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advanced_app/presentation/resources_data/color_manager.dart';
import 'package:advanced_app/presentation/resources_data/values_managers.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources_data/assets_manager.dart';
import '../../resources_data/routes_manager.dart';
import '../../resources_data/strings_manager.dart';
import '../../resources_data/styles_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _registerViewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreference _appPreference = instance<AppPreference>();

  final _formkey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _mobileEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _registerViewModel.start();

    _userNameEditingController.addListener(() {
      _registerViewModel.setUserName(_userNameEditingController.text);
    });

    _emailEditingController.addListener(() {
      _registerViewModel.setEmail(_emailEditingController.text);
    });

    _mobileEditingController.addListener(() {
      _registerViewModel.setMobileNumber(_mobileEditingController.text);
    });

    _passwordEditingController.addListener(() {
      _registerViewModel.setPassword(_passwordEditingController.text);
    });

    _registerViewModel.isUserRegisteredInSuccessfullyStreamController.stream
        .listen((isRegistered) {
      //Navigate to main Screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreference.setUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(
          color: ColorManager.primary,
        ),
      ),
      body: StreamBuilder<FlowState>(
        stream: _registerViewModel.outPutState,
        builder: (context, snapShot) {
          return snapShot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _registerViewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p5),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
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

              //UserName Text Form
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _registerViewModel.outputErrorUserName,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        //todo
                        keyboardType: TextInputType.text,
                        controller: _userNameEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.userName,
                          labelText: AppStrings.userName,
                          errorText: snapshot.data,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),

              //Country Mobile Code & Mobile
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p18),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            //update view model with code
                            _registerViewModel.setCountryCode(
                                country.dialCode ?? Constants.token);
                          },

                          //todo add +20  to the viewObject in the viewModel to store default value if not select anything first
                          initialSelection: '+20',
                          favorite: const ['+39', 'FR', '+966'],
                          // optional. Shows only country name and flag
                          showCountryOnly: true,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                          hideMainText: true,
                          // optional. aligns the flag and the Text left
                          //alignLeft: false,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<String?>(
                            stream: _registerViewModel.outputErrorMobileNumber,
                            builder: ((context, snapshot) {
                              return TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.]+')),
                                ],
                                controller: _mobileEditingController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.mobileNumber,
                                  labelText: AppStrings.mobileNumber,
                                  errorText: snapshot.data,
                                ),
                              );
                            })),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),

              // Email Text Form
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _registerViewModel.outputErrorEmail,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailHint,
                          errorText: snapshot.data,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),

              // Password  Text Form
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                    stream: _registerViewModel.outputErrorPassword,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: snapshot.data,
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: AppSize.s18,
              ),

              //Pick Image
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p28,
                  ),
                  child: Container(
                    height: AppSize.s40,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.s8)),
                      border: Border.all(
                        color: ColorManager.grey,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _getMediaWidget(),
                    ),
                  )),

              const SizedBox(
                height: AppSize.s28,
              ),

              //Button Register
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _registerViewModel.outputAreAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _registerViewModel.register();
                              }
                            : null,
                        child: const Text(AppStrings.register),
                      ),
                    );
                  },
                ),
              ),

              // Text Button Already have account
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.alreadyHaveAccount,
                    textAlign: TextAlign.end,
                    style: getMediumStyle(
                        color: ColorManager.primary, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppStrings.photoCamera),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Text(AppStrings.profilePicture),
          ),
          Flexible(
            child: StreamBuilder<File>(
                stream: _registerViewModel.outputProfilePicture,
                builder: (context, snapshot) {
                  return _imagePickedByUser(snapshot.data);
                }),
          ),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCamera)),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? imageFile) {
    if (imageFile != null && imageFile.path.isNotEmpty) {
      // return image
      return Image.file(imageFile);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _registerViewModel.dispose();
    super.dispose();
  }
}

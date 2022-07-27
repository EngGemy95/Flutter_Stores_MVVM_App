import 'dart:async';
import 'dart:io';

import 'package:advanced_app/app/constants.dart';
import 'package:advanced_app/app/functions.dart';
import 'package:advanced_app/domain/usecase/register_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:advanced_app/presentation/common/freezed_data_class.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_app/presentation/resources_data/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController userNameStreamController =
      StreamController<String>.broadcast();
  StreamController mobileNumberStreamController =
      StreamController<String>.broadcast();
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController passwordStreamController =
      StreamController<String>.broadcast();
  StreamController profilePictureStreamController =
      StreamController<File>.broadcast();
  StreamController areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();

  final RegisterUseCase _registerUseCase;
  var registerObject = RegisterObject("", "", "", "", "", "");
  RegisterViewModel(this._registerUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNameStreamController.close();
    mobileNumberStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePictureStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

// Inputs

  @override
  Sink get inputUserName => userNameStreamController.sink;

  @override
  Sink get inpuMobileNumber => mobileNumberStreamController.sink;

  @override
  Sink get inputEmail => emailStreamController.sink;

  @override
  Sink get inputPassword => passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => profilePictureStreamController.sink;

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.email,
            registerObject.password,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            ""
            //registerObject.profilePicture,
            )))
        .fold((failure) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (data) {
      inputState.add(ContentState());
      isUserRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      // update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset user name value in register view object
      registerObject = registerObject.copyWith(userName: Constants.empty);
    }
    _validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      // update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset country code value in register view object
      registerObject =
          registerObject.copyWith(countryMobileCode: Constants.empty);
    }
    _validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset Email value in register view object
      registerObject = registerObject.copyWith(email: Constants.empty);
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inpuMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      // update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: Constants.empty);
    }
    _validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: Constants.empty);
    }
    _validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      // update register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: Constants.empty);
    }
    _validate();
  }

  // OutPuts

  @override
  Stream<bool> get outputIsUserNameValid => userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outputIsUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.userNameisInvalid);

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.emailError);

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid);

  @override
  Stream<bool> get outputIsPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid);

  @override
  Stream<File> get outputProfilePicture =>
      profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  //Private Methods

  bool _isUserNameValid(String userName) {
    return userName.length >= 3;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length == 11;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  _validate() {
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  Sink get inputUserName;
  Sink get inpuMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;

  register();
  setUserName(String userName);
  setEmail(String email);
  setPassword(String password);
  setMobileNumber(String mobileNumber);
  setProfilePicture(File profilePicture);
  setCountryCode(String countryCode);
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputAreAllInputsValid;
}

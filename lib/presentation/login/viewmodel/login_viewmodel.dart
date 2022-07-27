import 'dart:async';

import 'package:advanced_app/domain/usecase/login_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:flutter/cupertino.dart';

import '../../common/freezed_data_class.dart';

class LoginViewmodel extends BaseViewModel
    with LoginViewmodelInput, LoginViewmodelOutput {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  var loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;
  LoginViewmodel(this._loginUseCase);

  //Inputs

  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputpassword => _passwordStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  setpassword(String password) {
    inputpassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((failure) {
      //left -> failue
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (data) {
      //right -> data (success)
      //content
      inputState.add(ContentState());
      isUserLoggedInSuccessfullyStreamController.add(true);
      //navigate to main Screen
    });
  }

  //Outputs
  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => isUserNameValid(userName));

  @override
  Stream<bool> get outIspasswordValid => _passwordStreamController.stream
      .map((password) => isPasswodValid(password));

  @override
  Stream<bool> get outIsAreAllInputsValid =>
      _areAllInputsValidStreamController.stream.map((_) {
        return _areAllInputsValid();
      });

  bool isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool isPasswodValid(String password) {
    return password.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return isUserNameValid(loginObject.userName) &&
        isPasswodValid(loginObject.password);
  }
}

abstract class LoginViewmodelInput {
  setUserName(String userName);
  setpassword(String password);

  login();

  Sink get inputUserName;
  Sink get inputpassword;
  Sink get inputAreAllInputsValid;
}

abstract class LoginViewmodelOutput {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsAreAllInputsValid;
}

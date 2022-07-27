import 'dart:async';

import 'package:advanced_app/app/functions.dart';
import 'package:advanced_app/domain/usecase/forgetpassword_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgetPasswordViewModel extends BaseViewModel
    with ForgetPasswordViewModelInput, ForgetPasswordViewModelOutput {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  String email = "";

  final ForgetPasswordUseCase _forgetPasswordUseCase;
  ForgetPasswordViewModel(this._forgetPasswordUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  forgetPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgetPasswordUseCase.execute(email)).fold(
      (failure) {
        inputState.add(
            ErrorState(StateRendererType.popupErrorState, failure.message));
      },
      (supportMessage) {
        inputState.add(SuccessState(supportMessage));
      },
    );
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _isAllInputValid());

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract class ForgetPasswordViewModelInput {
  forgetPassword();
  setEmail(String email);
  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgetPasswordViewModelOutput {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}

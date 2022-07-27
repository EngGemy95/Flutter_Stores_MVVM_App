import 'dart:async';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  //Shared variables and functions that will be use through any view model

  final StreamController _inputStreamController = BehaviorSubject<FlowState>();

  @override
  void dispose() {
    _inputStreamController.close();
  }

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outPutState =>
      _inputStreamController.stream.map((flowState) => flowState);
}

abstract class BaseViewModelInputs {
  void start(); // start view model job
  void dispose(); // will be called when view model dies

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outPutState;
}

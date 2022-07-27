import 'package:advanced_app/app/constants.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/resources_data/strings_manager.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

//Loading State (PopUp , FullScreen)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState(
      {required this.stateRendererType, this.message = AppStrings.loading});

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//Error State (PopUp , FullScreen)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Content state
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

// Empty state
class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

// Success State
class SuccessState extends FlowState {
  String message;

  SuccessState(
    this.message,
  );

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccess;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, getStateRendererType(), getMessage());
            //show content ui of the screen
            return contentScreenWidget;
          } else {
            // show Full Screen loading
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            // show popup Error
            showPopup(context, getStateRendererType(), getMessage());
            //show content ui of the screen
            return contentScreenWidget;
          } else {
            // show Full Screen Error State
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case EmptyState:
        {
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: () {},
          );
        }
      case SuccessState:
        {
          dismissDialog(context);
          showPopup(context, StateRendererType.popupSuccess, getMessage(),
              title: AppStrings.success);
          return contentScreenWidget;
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      default:
        dismissDialog(context);
        return contentScreenWidget;
    }
  }

  //check if any dialog open or not
  _isCurrentDialogShowing(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent != true;
  }

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})));
  }
}

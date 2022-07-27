import 'package:advanced_app/app/constants.dart';
import 'package:advanced_app/presentation/resources_data/assets_manager.dart';
import 'package:advanced_app/presentation/resources_data/color_manager.dart';
import 'package:advanced_app/presentation/resources_data/strings_manager.dart';
import 'package:advanced_app/presentation/resources_data/styles_manager.dart';
import 'package:advanced_app/presentation/resources_data/values_managers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateRendererType {
  // Popup State ( Dialog )
  popupLoadingState,
  popupErrorState,
  popupSuccess,
  //Full Screen ( Full Screen )
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  //General
  contentState,
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  StateRenderer({
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title = Constants.empty,
    required this.retryActionFunction,
  });

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(
            context, [_getAnimatedImage(JsonAssets.loading)]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok, context),
        ]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain, context),
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      case StateRendererType.popupSuccess:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(title),
          _getMessage(message),
          _getRetryButton(AppStrings.ok, context),
        ]);
      case StateRendererType.contentState:
        return Container();

      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
              ),
            ]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: AppSize.s18,
          ),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (stateRendererType ==
                      StateRendererType.fullScreenErrorState) {
                    // call retry Function
                    retryActionFunction.call();
                  } else {
                    //Popup Error State
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonTitle))),
      ),
    );
  }
}

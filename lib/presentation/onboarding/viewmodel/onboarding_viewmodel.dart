import 'dart:async';

import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';

import '../../resources_data/assets_manager.dart';
import '../../resources_data/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controllers outputs
  final StreamController _streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // OnBoarding ViewModel Input
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    //view model start your job
    _list = _getSliderData();
    postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    postDataToView();
  }

  //OnBoarding viewModel Input
  @override
  Sink get inputSliderViewObject => _streamController.sink;

  //OnBoarding viewModel Output
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  //onBoarding ViewModel private functions
  void postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }

  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onBoardingTitle1,
            AppStrings.onBoardingSubTitle1, ImageAssets.onboardingLogo1),
        SliderObject(AppStrings.onBoardingTitle2,
            AppStrings.onBoardingSubTitle2, ImageAssets.onboardingLogo2),
        SliderObject(AppStrings.onBoardingTitle3,
            AppStrings.onBoardingSubTitle3, ImageAssets.onboardingLogo3),
        SliderObject(AppStrings.onBoardingTitle4,
            AppStrings.onBoardingSubTitle4, ImageAssets.onboardingLogo4),
      ];
}

// inputs mean that "Orders" that our viewModel will reveive from view
abstract class OnBoardingViewModelInputs {
  int goNext(); // when user clicks on right arrow or swipe left
  int goPrevious(); // when user clicks on left arrow swipe right
  void onPageChanged(int index);

  //stream controller input
  Sink get inputSliderViewObject;
}

// this will communicate viewModel with view
abstract class OnBoardingViewModelOutputs {
  //stream controller outputs
  Stream<SliderViewObject> get outputSliderViewObject;
}

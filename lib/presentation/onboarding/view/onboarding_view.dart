import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:advanced_app/presentation/resources_data/assets_manager.dart';
import 'package:advanced_app/presentation/resources_data/color_manager.dart';
import 'package:advanced_app/presentation/resources_data/constants_manager.dart';
import 'package:advanced_app/presentation/resources_data/routes_manager.dart';
import 'package:advanced_app/presentation/resources_data/strings_manager.dart';
import 'package:advanced_app/presentation/resources_data/values_managers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/model/models.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  final AppPreference _appPreference = instance<AppPreference>();

  _bind() {
    _appPreference.setOnBoardingScreenViewed();
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder: ((context, snapshot) {
          return getContentWidget(snapshot.data);
        }));
  }

  Widget getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: sliderViewObject.numOfSliders,
          onPageChanged: (index) {
            _viewModel.onPageChanged(index);
          },
          itemBuilder: ((context, index) {
            // return onBoarding Page
            return OnBoardingPage(sliderViewObject.sliderObject);
          }),
        ),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(AppStrings.skip,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
              //Widget indicator and arows
              _getBottomSheetWidget(sliderViewObject),
            ],
          ),
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //left Arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              onTap: (() {
                //go to previous
                _pageController.animateToPage(
                  _viewModel.goPrevious(),
                  duration: const Duration(
                      milliseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut,
                );
              }),
              child: SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.leftArrow),
              ),
            ),
          ),
          // circle
          Row(
            children: [
              for (int position = 0;
                  position < sliderViewObject.numOfSliders;
                  position++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child:
                      _getProperCircle(position, sliderViewObject.currentIndex),
                )
            ],
          ),
          //Right Arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              onTap: (() {
                //go to next
                _pageController.animateToPage(
                  _viewModel.goNext(),
                  duration: const Duration(
                      milliseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut,
                );
              }),
              child: SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrow),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircle);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircle);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: AppSize.s40),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(
              _sliderObject.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: AppSize.s40),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(
              _sliderObject.subTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: AppSize.s60),
          SvgPicture.asset(_sliderObject.image),
        ],
      ),
    );
  }
}

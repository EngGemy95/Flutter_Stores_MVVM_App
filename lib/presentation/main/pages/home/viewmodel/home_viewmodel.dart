import 'dart:async';
import 'dart:ffi';

import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/usecase/home_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final StreamController _homeDataStreamController =
      BehaviorSubject<HomeViewObject>();
  // final StreamController _serviceStreamController =
  //     BehaviorSubject<List<Service>>();
  // final StreamController _storeStreamController =
  //     BehaviorSubject<List<Store>>();

  //Constructor
  HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

  @override
  void start() {
    _getHomeData();
  }

  @override
  void dispose() {
    _homeDataStreamController.close();
    // _serviceStreamController.close();
    // _storeStreamController.close();
    super.dispose();
  }

  //Inputs

  @override
  Sink get inputHomeObject => _homeDataStreamController.sink;

  // @override
  // Sink get inputStores => _storeStreamController.sink;

  // @override
  // Sink get inputServices => _serviceStreamController.sink;

  // Outputs

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _homeDataStreamController.stream.map((homeData) => homeData);

  // @override
  // Stream<List<Service>> get outputServices =>
  //     _serviceStreamController.stream.map((services) => services);

  // @override
  // Stream<List<Store>> get outputStores =>
  //     _storeStreamController.stream.map((stores) => stores);

  // private function
  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void)).fold((failure) {
      //left -> failue
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (homeObject) {
      //right -> data (success)
      //content
      inputState.add(ContentState());
      // inputStores.add(homeObject.homeData?.stores);
      // inputServices.add(homeObject.homeData?.services);
      inputHomeObject.add(HomeViewObject(homeObject.homeData.services,
          homeObject.homeData.banners, homeObject.homeData.stores));
      //navigate to main Screen
    });
  }
}

abstract class HomeViewModelInput {
  Sink get inputHomeObject;
  // Sink get inputStores;
  // Sink get inputBanners;
}

abstract class HomeViewModelOutput {
  Stream<HomeViewObject> get outputHomeData;
  // Stream<List<Store>> get outputStores;
  // Stream<List<BannerAd>> get outputBanners;
}

class HomeViewObject {
  List<Service> services;

  List<BannerAd> banners;

  List<Store> stores;

  HomeViewObject(this.services, this.banners, this.stores);
}

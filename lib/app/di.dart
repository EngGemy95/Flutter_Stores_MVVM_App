import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/data/data_source/local_data_source.dart';
import 'package:advanced_app/data/data_source/remote_data_source.dart';
import 'package:advanced_app/data/network/app_api.dart';
import 'package:advanced_app/data/network/dio_factory.dart';
import 'package:advanced_app/data/network/network_info.dart';
import 'package:advanced_app/data/repository/repository_impl.dart';
import 'package:advanced_app/domain/repository/repository.dart';
import 'package:advanced_app/domain/usecase/forgetpassword_usecase.dart';
import 'package:advanced_app/domain/usecase/home_usecase.dart';
import 'package:advanced_app/domain/usecase/login_usecase.dart';
import 'package:advanced_app/domain/usecase/register_usecase.dart';
import 'package:advanced_app/presentation/forget_password/viewmodel/forgetpassword_viewmodel.dart';
import 'package:advanced_app/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_app/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:advanced_app/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

// We put async because the shared prefs require await for Future
Future<void> initAppModule() async {
  // App Module , it is a module where we put all generic dependencies

  // shared prefs instance

  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreference>(() => AppPreference(sharedPrefs));
  // or this
  //instance.registerLazySingleton<AppPreference>(() => AppPreference(instance<SharedPreferences>()));

  //network info instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory instance
  instance.registerLazySingleton<DioFactory>(
      () => DioFactory(instance<AppPreference>()));

  Dio dio = await instance<DioFactory>().getDio();

  // App Service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // Repositoy instance
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    //LoginUseCase instance
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    //LoginViewmodel instance
    instance.registerFactory<LoginViewmodel>(() => LoginViewmodel(instance()));
  }
}

initForgetPasswordModule() {
  if (!GetIt.I.isRegistered<ForgetPasswordUseCase>()) {
    //ForgetPasswordUseCase instanceForgetPasswordUseCase
    instance.registerFactory<ForgetPasswordUseCase>(
        () => ForgetPasswordUseCase(instance()));

    //ForgetPasswordViewModel instance
    instance.registerFactory<ForgetPasswordViewModel>(
        () => ForgetPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    //RegisterUseCase instanceRegisterUseCase
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));

    //RegisterViewModel instance
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));

    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    //HomeUseCase instanceHomeUseCase
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));

    //HomeViewModel instance
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

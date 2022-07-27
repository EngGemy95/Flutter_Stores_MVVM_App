import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final AppPreference _appPreference;

  DioFactory(this._appPreference);

  Future<Dio> getDio() async {
    //get language from shared preference
    String language = await _appPreference.getAppLanguage();

    Dio dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: language
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: Constants.API_TIME_OUT,
      sendTimeout: Constants.API_TIME_OUT,
    );

    if (!kReleaseMode) {
      // It is debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
    return dio;
  }
}

import 'package:advanced_app/data/data_source/local_data_source.dart';
import 'package:advanced_app/data/mapper/mapper.dart';
import 'package:advanced_app/data/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../../domain/model/models.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import '../network/Failure.dart';
import '../network/network_info.dart';
import '../network/requests.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , its safe to call API
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          //success
          //return Either right
          //return data
          return Right(response.toDomain());
        } else {
          //failure -- return business error
          //return Either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      //return Either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgetPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , its safe to call API
        final response = await _remoteDataSource.forgetPassword(email);
        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , its safe to call API
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      //return response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      // return respone from server
      if (await _networkInfo.isConnected) {
        try {
          //its connected to internet , its safe to call API
          final response = await _remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.SUCCESS) {
            //success
            //return Either right
            //return data

            //Save HomeResponse to cache
            _localDataSource.saveHomeToCache(response);

            return Right(response.toDomain());
          } else {
            //failure -- return business error
            //return Either left
            return Left(Failure(ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        //return Either left
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}

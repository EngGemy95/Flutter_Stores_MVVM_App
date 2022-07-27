import 'package:advanced_app/data/network/Failure.dart';
import 'package:advanced_app/domain/repository/repository.dart';
import 'package:advanced_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUseCase implements BaseUseCase<String, String> {
  final Repository _repository;

  ForgetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String email) async {
    return await _repository.forgetPassword(email);
  }
}

import 'package:advanced_app/data/network/Failure.dart';
import 'package:advanced_app/data/network/requests.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/repository/repository.dart';
import 'package:advanced_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}

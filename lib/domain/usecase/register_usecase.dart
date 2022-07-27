import 'package:advanced_app/data/network/Failure.dart';
import 'package:advanced_app/data/network/requests.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/repository/repository.dart';
import 'package:advanced_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
      input.userName,
      input.email,
      input.password,
      input.countryMobileCode,
      input.mobileNumber,
      input.profilePicture,
    ));
  }
}

class RegisterUseCaseInput {
  String userName;
  String email;
  String password;
  String countryMobileCode;
  String mobileNumber;
  String profilePicture;

  RegisterUseCaseInput(this.userName, this.email, this.password,
      this.countryMobileCode, this.mobileNumber, this.profilePicture);
}

import 'package:advanced_app/data/network/Failure.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/repository/repository.dart';
import 'package:advanced_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}

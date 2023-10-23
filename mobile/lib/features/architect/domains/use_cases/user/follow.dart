import '../../../../../core/use_cases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';

class FollowUser implements UseCase<User, Params> {
  final UserRepository repository;

  const FollowUser(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.follow(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params(this.id);

  @override
  List<Object?> get props => [id];
}

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/AppFailure.dart';

typedef FutureEither<T> = Future<Either<Appfailure, T>>;
typedef FutureVoid = FutureEither<void>;

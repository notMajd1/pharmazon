import 'package:dartz/dartz.dart';
import 'package:pharmazon/core/errors/failures.dart';
import 'package:pharmazon/features/home/data/models/classifications_model.dart';
import 'package:pharmazon/features/home/data/models/medicine_model.dart';

abstract class HomeRepo {
  Future<void> logOut();
  Future<Either<Failure, List<ClassificationsModel>>> fetchClassifications();
  Future<Either<Failure, List<MedicineModel>>> fetchMedicineOfClassification(
      {required String classification});
}

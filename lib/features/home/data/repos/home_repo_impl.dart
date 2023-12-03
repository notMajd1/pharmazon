import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmazon/blocs/token_cubit/token_cubit.dart';
import 'package:pharmazon/constants.dart';
import 'package:pharmazon/core/errors/failures.dart';
import 'package:pharmazon/core/shared_models/classifications_model.dart';
import 'package:pharmazon/core/shared_models/medicine_model.dart';
import 'package:pharmazon/core/utils/api_service.dart';
import 'package:pharmazon/features/home/data/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService _apiService;
  final TokenCubit tokenCubit;

  HomeRepoImpl(this._apiService) : tokenCubit = GetIt.instance<TokenCubit>();
  @override
  Future<void> logOut() async {
    try {
      await _apiService.delete(
          url: '$kBaseUrl/logout',
          body: {
            'api_token': tokenCubit.state,
          },
          token: null

          // Replace with your token if needed
          );
      await tokenCubit.deleteSavedToken();
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<Either<Failure, List<ClassificationsModel>>>
      fetchClassifications() async {
    //make the token with the token cubit
    await tokenCubit.fetchSavedToken();

    try {
      print(tokenCubit.state);
      final data = await _apiService.get(
          url: '$kBaseUrl/getAll', token: tokenCubit.state, body: null);
      List<ClassificationsModel> classifications = [];
      for (var item in data['classifications']) {
        classifications.add(ClassificationsModel(clssification: item));
      }

      return Right(classifications);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicineModel>>> fetchMedicineOfClassification(
      {required String classification}) async {
    try {
      final data = await _apiService.get(
          url: '$kBaseUrl/getAllMedicine?calssification=$classification',
          token: tokenCubit.state,
          body: null);
      List<MedicineModel> medicines = [];
      for (var item in data['medicines']) {
        medicines.add(MedicineModel.fromJson(item));
      }

      return Right(medicines);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}

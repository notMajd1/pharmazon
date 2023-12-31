import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmazon/blocs/token_cubit/token_cubit.dart';
import 'package:pharmazon/core/errors/failures.dart';
import 'package:pharmazon/constants.dart';
import 'package:pharmazon/core/utils/api_service.dart';
import 'package:pharmazon/features/order/data/models/date_model.dart';
import 'package:pharmazon/features/order/data/models/order/order.details.dart';
import 'package:pharmazon/features/order/data/models/order_item_model.dart';
import 'package:pharmazon/features/order/data/repos/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  final ApiService _apiService;
  final TokenCubit tokenCubit;

  OrderRepoImpl(this._apiService) : tokenCubit = GetIt.instance<TokenCubit>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> postDelivery(
      List<OrderItemModel?> orderItems,double totalPrice) async {
    try {
    
      final data = await _apiService.post(
          url: '$kBaseUrl/order',
          token: tokenCubit.state,
          body: {"order": orderItems},
          header: totalPrice
          );
      // List<OrderItemModel> medicines = [];
      // print(data);
      // for (var item in data['order']) {
      //   medicines.add(OrderItemModel.fromJson(item));
      // }

      return Right(data);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DateModel>>> getDatesFromUser() async{
      try {
      final data = await _apiService.get(
        url: '$kBaseUrl/getTDate',
        token: tokenCubit.state, body: null,
      );
      List<DateModel> dates = [];
      print(data);
      for (var item in data['order_dates']) {
        dates.add(DateModel.fromJson(item));
      }
      return Right(dates);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }




   
  @override
  Future<Either<Failure, OrderDetails>> getOrderDetailsFromDate({required DateModel dateModel}) async{
        try {
      final data = await _apiService.post(
        url: '$kBaseUrl/getOrder',
        token: tokenCubit.state,
          body: {
            "date": dateModel.date
          }
      );
      OrderDetails orderDetailsModel= OrderDetails.fromJson(data) ;
      print(data);   
      return Right(orderDetailsModel);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}

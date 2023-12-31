import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmazon/constants.dart';
import 'package:pharmazon/core/utils/functions/custom_snack_bar.dart';
import 'package:pharmazon/core/widgets/custom_error.dart';
import 'package:pharmazon/core/widgets/custom_loading.dart';
import 'package:pharmazon/features/home/presentation/views/widgets/medicines_list_view.dart';
import 'package:pharmazon/features/order/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:pharmazon/features/order/presentation/manager/order_cubit/order_cubit.dart';
import 'package:pharmazon/features/order/presentation/manager/order_cubit/order_state.dart';
import 'package:pharmazon/generated/l10n.dart';

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({
    super.key,
  });

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

bool isPressed = false;

class _OrderViewBodyState extends State<OrderViewBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              context.pop();
              customSnackBar(context, state.orderItems);
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const CustomLoading();
            }
            if (state is OrderFailure) {
              return CustomError(errMessage: state.errMessage);
            }
            final medicines =
                BlocProvider.of<CartCubit>(context).getOrderMedicines();

            if (medicines.isNotEmpty) {
              return Expanded(
                child: MedicinesListView(
                  medicines: medicines,
                  isOrder: true,
                  isCart: true,
                ),
              );
            }
            return Center(
              child: Center(child: Text(S.of(context).ThereIsNoMedicines)),
            );
          },
        ),
        SizedBox(
          width: double.infinity,
          height: 2,
          child: Container(
            color: kAppColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(S.of(context).totalPrice),
              const Spacer(),
              Text(BlocProvider.of<CartCubit>(context)
                  .getTotalPrice()
                  .toStringAsFixed(2))
            ],
          ),
        ),
        if (BlocProvider.of<CartCubit>(context).getOrderMedicines().isNotEmpty)
          if (!isPressed)
            ElevatedButton(
                onPressed: ()async {
                  setState(() {
                    isPressed = true;
                  });
                  BlocProvider.of<OrderCubit>(context).postDelivery();
                  BlocProvider.of<CartCubit>(context).resetItems();
                //  BlocProvider.of<DatesCubit>(context).fetchDateFromUser();
                  isPressed = false;
                },
                child: Text(S.of(context).sendOrder))
      ],
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazon/features/order/data/models/order/pharmaceutical.details.dart';
import 'package:pharmazon/features/order/data/models/order_item_model.dart';
import 'package:pharmazon/features/order/presentation/manager/cart_cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  List<OrderItemModel?> orderItems = [];
  List<Pharmaceutical> orderMedicines = [];
  double totalPrice = 0;

  CartCubit() : super(CartInitial());

  List<Pharmaceutical> getOrderMedicines() {
    return orderMedicines;
  }

  bool checkIfEmpty() {
    return orderItems.isEmpty;
  }

  void resetItems() {
    orderItems = [];

    orderMedicines = [];

    totalPrice = 0;
  }
void addItem(int quantity, Pharmaceutical orderMedicine) {
  var existingItem = orderItems
      .firstWhere((item) => item!.id == orderMedicine.id, orElse: () => null);

  if (existingItem != null) {
    existingItem.orderQuantity = (existingItem.orderQuantity ?? 0) + quantity;
    totalPrice += orderMedicine.price! * quantity; // Add the price of the added items to the total

    // Check if the quantity is zero after modifying it
    if (existingItem.orderQuantity == 0) {
      orderItems.remove(existingItem); // Remove the item from the orderItems list
      orderMedicines.remove(orderMedicine);
    }
  } else {
    orderItems.add(OrderItemModel(id: orderMedicine.id, orderQuantity: quantity));
    orderMedicines.add(orderMedicine);
    totalPrice += orderMedicine.price! * quantity; // Add the price of the new item to the total
  }
  emit(CartUpdated(orderItems));
}

  int getItemQuatity(int id) {
    var existingItem =
        orderItems.firstWhere((item) => item!.id == id, orElse: () => null);

    if (existingItem == null) {
      return 0;
    } else {
      return existingItem.orderQuantity!;
    }
  }

  double getTotalPrice() {
    return totalPrice;
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/order_remote_data_source.dart';
import '../../../domain/order_data_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRemoteDataSource _orderRemoteDataSource;
  StreamSubscription? _realTimeSubscription;
  StreamSubscription? _periodicSubscription;
  OrderCubit(this._orderRemoteDataSource) : super(OrderInitial());

  Future<void> createTransaction({
    required int price,
    required String email,
    required String startDate,
    required String endDate,
    required String name
  }) async {
    emit(OrderLoading());
    try {
      final response = await _orderRemoteDataSource.createTransaction(price: price, email: email, startDate: startDate,
          endDate: endDate, name: name);
      emit(OrderPending('Redirecting to payment page...'));


    } catch (e) {
      emit(OrderError('An error occurred: ${e.toString()}'));
    }
  }

  void checkTransaction({
    required TransactionResponse response
}) {
    _realTimeSubscription?.cancel();
    _periodicSubscription?.cancel();
    _realTimeSubscription  = _orderRemoteDataSource.startListeningToFirestore(response.orderId, (status) {
        switch (status) {
        case TransactionStatus.success:
        emit(OrderSuccess('Payment Successful'));
        break;
        case TransactionStatus.pending:
        emit(OrderPending('Payment is pending...'));
        break;
        case TransactionStatus.failed:
        emit(OrderFailureServer('Payment Failed'));
        break;
        case TransactionStatus.unknown:
        emit(OrderError('Unknown status received'));
        break;
        }
        // }
        });
}
  @override
  Future<void> close() {
    // Stop the subscriptions
    _realTimeSubscription?.cancel();
    _periodicSubscription?.cancel();
    return super.close();
  }

  void resetState() {
    emit(OrderInitial());
  }

//   Stream<void> checkTransaction({
//     required
// }) {
// _orderRemoteDataSource.startListeningToFirestore(response.orderId, (status) {
//   switch (status) {
//     case TransactionStatus.success:
//       emit(OrderSuccess('Payment Successful'));
//       break;
//     case TransactionStatus.pending:
//       emit(OrderPending('Payment is pending...'));
//       break;
//     case TransactionStatus.failed:
//       emit(OrderFailure('Payment Failed'));
//       break;
//     case TransactionStatus.unknown:
//       emit(OrderError('Unknown status received'));
//       break;
//   }
// }
// });
//
//   }
}

part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final String message;
  OrderSuccess(this.message);
}

class OrderPending extends OrderState {
  // final TransactionResponse message;
  final String message;
  OrderPending(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class OrderFailureServer extends OrderState {
  final String errorMessage;
  OrderFailureServer(this.errorMessage);
}

class OrderError extends OrderState {
  final String error;
  OrderError(this.error);
}
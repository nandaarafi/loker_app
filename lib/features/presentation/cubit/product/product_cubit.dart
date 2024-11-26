import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokerapps/features/data/product_remote_data_source.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void getProductStatus() {
    emit(ProductLoading());

    try {
      ProductRemoteDataSource().getProductStatusStream().listen((products) {
        emit(ProductLoaded(products));  // Emit state loaded dengan data produk
      });
    } catch (e) {
      emit(ProductError('Failed to fetch products: $e'));
    }
  }
}

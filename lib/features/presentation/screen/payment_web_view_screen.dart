import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokerapps/core/routes/constants.dart';
import 'package:lokerapps/core/routes/routes.dart';
import 'package:lokerapps/core/widgets/custom_dialog.dart';
import 'package:lokerapps/features/presentation/cubit/order/order_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/order_remote_data_source.dart';
import '../../domain/order_data_model.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final TransactionResponse? response;

  const PaymentWebViewScreen({Key? key, required this.response})
      : super(key: key);

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  @override
  void initState() {
    context.read<OrderCubit>().checkTransaction(response: widget.response!);
    super.initState();
  }
  @override
  void dispose() {
    // Ensure the Cubit is closed and subscriptions are canceled
    context.read<OrderCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        AppRouter.router.go(Routes.orderScreenNamedPage);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order'),
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderPending) {
              return WebView(
                initialUrl: widget.response?.transactionRedirectUrl,
                javascriptMode: JavascriptMode.unrestricted,
              );
            } else if (state is OrderLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
          listener: (BuildContext context, OrderState state) {
            if (state is OrderSuccess) {
                CustomShowDialog.showOnPressedDialog(
                  context,
                  title: "Sukses",
                  message: "Pembayaran Sukses",
                  onPressed: () {
                    AppRouter.router.go(Routes.orderScreenNamedPage);
                  },
                  isCancel: false,
                );
                // AppRouter.router.go(Routes.successScreenNamedPage);
            } else if (state is OrderError) {
                CustomShowDialog.showCustomDialog(
                  context,
                  title: "Error",
                  message: state.error,
                  isCancel: true,
                );
            }
          },
        ),
        // body: widget.response?.transactionRedirectUrl == null
        //     ? Center(child: Text('No URL provided'))
        //     : WebView(
        //   initialUrl: widget.response?.transactionRedirectUrl,
        //   javascriptMode: JavascriptMode.unrestricted,
        // ),
      ),
    );
  }
}

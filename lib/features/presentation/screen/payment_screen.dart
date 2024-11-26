import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lokerapps/core/constants/colors.dart';
import 'package:lokerapps/core/helper/helper_functions.dart';
import 'package:lokerapps/core/widgets/custom_dialog.dart';
import 'package:lokerapps/features/domain/order_data_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/routes/constants.dart';
import '../../../core/routes/routes.dart';
import '../../data/order_remote_data_source.dart';
import '../cubit/order/order_cubit.dart';
import '../provider/cart_provider.dart';
import '../provider/control_bluetooth_provider.dart';
import '../widget/control_screen_list_tile.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  void dispose() {
    // _subscription?.cancel();
    // _periodicSubscription?.cancel();
    super.dispose();
  }
  late OrderCubit orderCubit;
  String _redirectUrl = '';
  bool _showWebView = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<BluetoothControlStateProvider>(context, listen: false).setIsBluetooth(false);

    orderCubit = context.read<OrderCubit>();
  }

  // void _onCreateTransaction() {
  //   orderCubit.createTransaction(price: 10000, email: 'budi.pra@example.com', startDate: );
  // }


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: LColors.grey.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: cart.items.isEmpty
                    ? Center(child: Text('Keranjang Anda Kosong'))
                    : ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final item = cart.items.values.toList()[index];
                    return CustomContainerListTile2(
                      title: item.name,
                      subtitle: ''
                          'Mulai: ${_formatDateTime(item.startDateTime)}\n'
                          'Akhir: ${_formatDateTime(item.endDateTime)}\n'
                          'Durasi: ${_formatDuration(item.duration)}\n'
                          'Harga: Rp. ${item.price}',
                      onPressed: () {
                        // Action when item is pressed, like removing item
                        cart.removeItem(item.id);
                      },
                    );
                  },
                ),
              ),
              BlocListener<OrderCubit, OrderState>(
                listener: (context, state) {
                  if (state is OrderSuccess) {
                    CustomShowDialog.showOnPressedDialog(context,
                        title: "Sukses",
                        message: 'Pembayaran Berhasil',
                        onPressed: () {

                      AppRouter.router.go(Routes.orderScreenNamedPage);

                          ///How to reset the bloc I still have OrderSuccess when I change to orderScreenNamedPage

                      },
                        isCancel: false
                    );
                    setState(() {
                      _showWebView = false;
                    });
                    // context.read<OrderCubit>().close();
                    print("error Successs");
                    // AppRouter.router.go(Routes.successScreenNamedPage);
                  } else if (state is OrderFailureServer) {
                    CustomShowDialog.showCustomDialog(context,
                        title: "Failed",
                        message: 'Payment Failed',
                        isCancel: false
                    );
                  } else if (state is OrderPending) {
                    // Optionally handle pending state
                  } else if (state is OrderError) {
                    CustomShowDialog.showCustomDialog(
                        context,
                        title: "Error",
                        message: "Payment Failed",
                        isCancel: true
                    );
                  }
                },
                child: Center(
                  child: _showWebView
                      ? WebView(
                    initialUrl: _redirectUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  )
                      : ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      fixedSize: Size(LHelperFunctions.screenWidth(context) * 0.8, 50),
                      backgroundColor: LColors.secondary
                    ),
                    onPressed: () async {
                      List<String> itemNames = cart.items.values.map((item) => item.name).toList();
                      bool hasDuplicates = itemNames.length != itemNames.toSet().length;

    if (hasDuplicates) {
      // Show an alert dialog or some UI to inform the user
      CustomShowDialog.showCustomDialog(
        context,
        title: "Error",
        message: "Kamu memiliki item duplikatv",
        isCancel: false,
      );
    } else {
      final TransactionResponse data = await OrderRemoteDataSource().createTransaction(
          price: cart.items.values.first.price,
          name: cart.items.values.first.name,
          email: 'test@gmail.com',
          startDate: cart.items.values.first.startDateTime.toIso8601String(),
          endDate: cart.items.values.first.endDateTime.toIso8601String()
      );
      String redirectUrl = data.transactionRedirectUrl;
      String orderId = data.orderId;
      AppRouter.router.go(Routes.paymentScreenNamedPage, extra: data);
    }

                    }/*_onCreateTransaction*/,
                    child: Text("Checkout",
                    style: TextStyle(fontFamily: 'Poppins',
                    color: LColors.white,
                    fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm, dd MMMM yyyy').format(dateTime);
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    return '$days hari, $hours jam, $minutes menit';
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lokerapps/core/widgets/custom_dialog.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../../../core/routes/constants.dart';
// import '../../../core/routes/routes.dart';
// import '../cubit/order/order_cubit.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//
//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _periodicSubscription?.cancel();
//     super.dispose();
//   }
//   late OrderCubit orderCubit;
//   String _redirectUrl = '';
//   bool _showWebView = false;
//
//   @override
//   void initState() {
//     super.initState();
//     orderCubit = context.read<OrderCubit>();
//   }
//
//   void _onCreateTransaction() {
//     orderCubit.createTransaction(price: 10000, email: 'budi.pra@example.com');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<OrderCubit, OrderState>(
//       listener: (context, state) {
//         if (state is OrderSuccess) {
//           CustomShowDialog.showOnPressedDialog(context,
//               title: "Sukses",
//               message: 'Pembayaran Berhasil',
//               onPressed: () {AppRouter.router.go(Routes.orderScreenNamedPage);},
//               isCancel: false
//           );
//           setState(() {
//             _showWebView = false;
//           });
//         } else if (state is OrderFailure) {
//           _showDialog('Payment Failed', state.errorMessage);
//
//         } else if (state is OrderPending) {
//           // Optionally handle pending state
//         } else if (state is OrderError) {
//           _showDialog('Error', state.error);
//         }
//       },
//       child: Center(
//         child: _showWebView
//             ? WebView(
//           initialUrl: _redirectUrl,
//           javascriptMode: JavascriptMode.unrestricted,
//         )
//             : ElevatedButton(
//           onPressed: _onCreateTransaction,
//           child: Text("Checkout"),
//         ),
//       ),
//     );
//   }
// }

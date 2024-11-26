// import 'package:flutter/material.dart';
// import 'package:lokerapps/core/routes/constants.dart';
// import 'package:lokerapps/core/routes/routes.dart';
// import 'package:lokerapps/features/data/order_remote_data_source.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// enum TransactionStatus { success, failure, pending }
//
// class OrderScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   MidtransSDK? _midtrans;
//   // TransactionStatus _transactionStatus = TransactionStatus.pending;
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     initSDK();
//   }
//
//   void initSDK() async {
//     if (_midtrans == null) {
//       _midtrans = await MidtransSDK.init(
//         config: MidtransConfig(
//           clientKey: dotenv.get('MIDTRANS_CLIENT_KEY'),
//           merchantBaseUrl: dotenv.get('MIDTRANS_MERCHANT_BASE_URL'),
//           colorTheme: ColorTheme(
//             colorPrimary: Theme.of(context).colorScheme.secondary,
//             colorPrimaryDark: Theme.of(context).colorScheme.secondary,
//             colorSecondary: Theme.of(context).colorScheme.secondary,
//           ),
//         ),
//       );
//       _midtrans?.setUIKitCustomSetting(
//           skipCustomerDetailsPages: true,
//           showPaymentStatus: true
//       );
//
//       _midtrans!.setTransactionFinishedCallback((result) {
//         handleTransactionResult(result);
//       });
//     }
//   }
//
//   void handleTransactionResult(TransactionResult result) {
//     if (!result.isTransactionCanceled) {
//       switch (result.transactionStatus) {
//         case TransactionResultStatus.capture:
//         case TransactionResultStatus.settlement:
//           showToast("Transaction Finished. ID: ${result.transactionId}");
//           break;
//         case TransactionResultStatus.pending:
//           showToast("Transaction Pending. ID: ${result.transactionId}");
//           break;
//         case TransactionResultStatus.deny:
//         case TransactionResultStatus.expire:
//         case TransactionResultStatus.cancel:
//           showToast("Transaction Failed. ID: ${result.transactionId}. Message: ${result.statusMessage}");
//           break;
//         default:
//           showToast("Transaction Finished with failure.");
//           break;
//       }
//     } else {
//       showToast("Transaction Canceled");
//     }
//   }
//
//   void showToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   void dispose() {
//     _midtrans?.removeTransactionFinishedCallback();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: () async {
//           initSDK();
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   String transactionToken = await OrderRemoteDataSource().createTransaction(
//                       email: "iwan@gmail.com",
//                       grossAmount: 5000
//                   );
//                   _midtrans?.startPaymentUiFlow(token: transactionToken);
//                 } catch (e) {
//                   print('Error: $e');
//                 }
//               },
//               child: Text("Checkout"),
//             ),
//
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   _midtrans!.setTransactionFinishedCallback((result) {
//                     // if (result.transactionStatus == 's')
//                     // AppRouter.router.go(Routes.successScreenNamedPage);
//                     print("Transaction Status :  ${result.transactionStatus}");
//                     // print(result.toJson());
//                   });
//                 } catch (e) {
//                   print('Error: $e');
//                 }
//               },
//               child: Text("Transaction Status"),
//             ),
//
//           ],
//         ),
//
//       ),
//     );
//   }
// }
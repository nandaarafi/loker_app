import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../domain/order_data_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TransactionResponse> createTransaction({
  required int price,
  required String email,
  required String name,
  required String startDate,
  required String  endDate
}) async {
    String serverKey = dotenv.get("MIDTRANS_SERVER_KEY");
    print(serverKey);

    // Encode the server key in Base64
    String encodedServerKey = base64Encode(utf8.encode('$serverKey:'));
    final response = await http.post(
      Uri.parse('${dotenv.get("MIDTRANS_MERCHANT_BASE_URL")}/createTransaction'),
      headers: <String, String>{
        // 'Authorization': 'Basic $encodedServerKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'gross_amount': price,
        'email': email,
        'startDate': startDate,
        'endDate': endDate,
        'namaLoker': name
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('orderId') && data.containsKey('transactionRedirectUrl')) {
        return TransactionResponse.fromJson(data);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message']);
    }
  }




  // final http.Client _client = http.Client();
  //
  //
  // Future<TransactionResponse> createTransaction({
  //   required int price,
  //   required String email,
  // }) async {
  //   final uri = Uri.parse('${dotenv.get("MIDTRANS_MERCHANT_BASE_URL")}/createTransaction');
  //   final headers = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };
  //
  //   try {
  //     final response = await _client.post(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode(<String, dynamic>{
  //         'gross_amount': price,
  //         'email': email,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data.containsKey('orderId') && data.containsKey('transactionRedirectUrl')) {
  //         return TransactionResponse.fromJson(data);
  //       } else {
  //         throw Exception('Invalid response format');
  //       }
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       throw Exception('Failed to create transaction: ${errorData['message']}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error creating transaction: ${e.toString()}');
  //   }
  // }

  StreamSubscription? _realTimeSubscription;
  StreamSubscription? _periodicSubscription;

  StreamSubscription startListeningToFirestore(
      String orderId,
      Function(TransactionStatus) onStatusChanged,
      ) {
    // Cancel existing subscriptions if they exist
    _realTimeSubscription?.cancel();
    _periodicSubscription?.cancel();

    // Real-time updates stream
    _realTimeSubscription = _firestore.collection('orders').doc(orderId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final orderData = snapshot.data()!;
        final transactionStatus = orderData['transaction_status'];
        onStatusChanged(_mapTransactionStatus(transactionStatus));
      }
    });

    // Periodic check every 10 seconds
    _periodicSubscription = Stream.periodic(Duration(seconds: 10)).listen((_) async {
      final snapshot = await _firestore.collection('orders').doc(orderId).get();
      if (snapshot.exists) {
        final orderData = snapshot.data()!;
        final transactionStatus = orderData['transaction_status'];
        onStatusChanged(_mapTransactionStatus(transactionStatus));
      }
    });

    return _realTimeSubscription!;
  }

  void stopListeningToFirestore() {
    _realTimeSubscription?.cancel();
    _periodicSubscription?.cancel();
  }
  // void startListeningToFirestore(String orderId, Function(TransactionStatus) onStatusChanged) {
  //   // Stream for real-time updates
  //   _firestore.collection('orders').doc(orderId).snapshots().listen((snapshot) {
  //     if (snapshot.exists) {
  //       final orderData = snapshot.data()!;
  //       final transactionStatus = orderData['transaction_status'];
  //       onStatusChanged(_mapTransactionStatus(transactionStatus));
  //     }
  //   });
  //
  //   // Periodic check every 10 seconds
  //   Stream.periodic(Duration(seconds: 10)).listen((_) {
  //     _firestore.collection('orders').doc(orderId).get().then((snapshot) {
  //       if (snapshot.exists) {
  //         final orderData = snapshot.data()!;
  //         final transactionStatus = orderData['transaction_status'];
  //         onStatusChanged(_mapTransactionStatus(transactionStatus));
  //       }
  //     });
  //   });
  // }

  TransactionStatus _mapTransactionStatus(String status) {
    switch (status) {
      case 'settlement':
        return TransactionStatus.success;
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.unknown;
    }
  }
  Stream<DocumentSnapshot> getProductStatusStreamLoker1() {
    return _firestore.collection('products').doc('ASGSPHogNkYUfgJi3L6E').snapshots();
  }
}

enum TransactionStatus { success, pending, failed, unknown }






// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// import '../domain/order_data_model.dart';
//
// class OrderRemoteDataSource {
//   final Dio _dio = Dio();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   OrderRemoteDataSource() {
//     _dio.options.baseUrl = dotenv.get("MIDTRANS_MERCHANT_BASE_URL");
//     _dio.options.headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//   }
//
//   Future<TransactionResponse> createTransaction({
//     required int price,
//     required String email,
//   }) async {
//     try {
//       final response = await _dio.post(
//         '/createTransaction',
//         data: jsonEncode(<String, dynamic>{
//           'gross_amount': price,
//           'email': email,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data.containsKey('orderId') && data.containsKey('transactionRedirectUrl')) {
//           return TransactionResponse.fromJson(data);
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         final errorData = response.data;
//         throw Exception('Failed to create transaction: ${errorData['message']}');
//       }
//     } catch (e) {
//       throw Exception('Error creating transaction: ${e.toString()}');
//     }
//   }
//
//   void startListeningToFirestore(String orderId, Function(TransactionStatus) onStatusChanged) {
//     // Stream for real-time updates
//     _firestore.collection('orders').doc(orderId).snapshots().listen((snapshot) {
//       if (snapshot.exists) {
//         final orderData = snapshot.data()!;
//         final transactionStatus = orderData['transaction_status'];
//         onStatusChanged(_mapTransactionStatus(transactionStatus));
//       }
//     });
//
//     // Periodic check every 10 seconds
//     Stream.periodic(Duration(seconds: 10)).listen((_) {
//       _firestore.collection('orders').doc(orderId).get().then((snapshot) {
//         if (snapshot.exists) {
//           final orderData = snapshot.data()!;
//           final transactionStatus = orderData['transaction_status'];
//           onStatusChanged(_mapTransactionStatus(transactionStatus));
//         }
//       });
//     });
//   }
//
//   TransactionStatus _mapTransactionStatus(String status) {
//     switch (status) {
//       case 'settlement':
//         return TransactionStatus.success;
//       case 'pending':
//         return TransactionStatus.pending;
//       case 'failed':
//         return TransactionStatus.failed;
//       default:
//         return TransactionStatus.unknown;
//     }
//   }
// }
//
// enum TransactionStatus { success, pending, failed, unknown }

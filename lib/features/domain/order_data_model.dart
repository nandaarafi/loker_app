import 'package:flutter/material.dart';

class TransactionResponse {
  final String orderId;
  final String transactionRedirectUrl;

  TransactionResponse({
    required this.orderId,
    required this.transactionRedirectUrl,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      orderId: json['orderId'] as String,
      transactionRedirectUrl: json['transactionRedirectUrl'] as String,
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final DateTime startDateTime;
  // final TimeOfDay startTime;
  final DateTime endDateTime;
  // final TimeOfDay endTime;

  CartItem({
    required this.id,
    required this.name,
    required this.startDateTime,
    // required this.startTime,
    required this.endDateTime,
    // required this.endTime,
  });

  // Method untuk mendapatkan durasi antara startDateTime dan endDateTime
  Duration get duration => endDateTime.difference(startDateTime);

  int get price {
    int calculatedPrice = (duration.inHours * 500).toInt();
    // Apply a minimum price limit
    if (calculatedPrice < 1000) {
      return 1000;
    }
    return calculatedPrice;
  }

}

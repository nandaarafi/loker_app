import 'package:flutter/material.dart';
import '../../domain/order_data_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  int _nextId = 1; // Counter untuk ID

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  Duration get totalDuration {
    return _items.values
        .fold(Duration.zero, (sum, item) => sum + item.duration);
  }

  void addItem(String name, DateTime startDateTime, DateTime endDateTime) {
    final id = 'item$_nextId'; // Generate ID dengan increment
    _nextId++; // Increment counter

    _items.putIfAbsent(
      id,
          () => CartItem(
        id: id,
        name: name,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      ),
    );
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
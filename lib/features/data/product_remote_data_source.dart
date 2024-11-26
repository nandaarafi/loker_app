import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRemoteDataSource {
  final CollectionReference productRef = FirebaseFirestore.instance.collection('products');

  // Method untuk mendapatkan status dari setiap dokumen
  Stream<List<Map<String, dynamic>>> getProductStatusStream() {
    // print("Test");
    return productRef.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        final data = {
          'id': doc.id,
          'status': doc['status'] ?? false,  // Default false jika tidak ada field 'status'
          'nama_loker': doc['nama_loker'] ?? "",  // Default false jika tidak ada field 'status'
          'pesan_buka': doc['pesan_buka'] ?? "",  // Default false jika tidak ada field 'status'
          'pesan_tutup': doc['pesan_tutup'] ?? "",  // Default false jika tidak ada field 'status'
        };

        // Print data untuk memeriksa hasil yang diambil
        print('Product ID: ${data['id']}, Status: ${data['status']}');

        return data;
      }).toList();
    });
  }
}

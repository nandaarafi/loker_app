import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lokerapps/core/routes/routes.dart';
import 'package:lokerapps/features/data/product_remote_data_source.dart';


class TestScreen extends StatefulWidget {
  final BluetoothDevice? server;
  TestScreen({required this.server});

  @override
  State<StatefulWidget> createState() => _TestScreenState();

}

class _TestScreenState extends State<TestScreen> {
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  void initState(){
    BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
      String errorMessage = 'Failed to connect to the device';
      if (error is PlatformException) {
        errorMessage = 'Cannot connect: ${error.message}';
      }
      //NOTES: Testing
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Connection Error'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    AppRouter.router.pop();
                    AppRouter.router.pop();
                    // Get.toNamed(Routes.homeNamedPage, arguments: server);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    });;
    super.initState();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: ElevatedButton(
      onPressed: () {();},
      child: Text("Get All Product Data"),

    )
    ),
    );
  }
}

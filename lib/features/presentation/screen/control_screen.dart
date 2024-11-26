import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lokerapps/core/constants/colors.dart';
import 'package:lokerapps/core/helper/helper_functions.dart';
import 'package:lokerapps/core/routes/routes.dart';
import 'package:lokerapps/core/widgets/custom_dialog.dart';
import 'package:lokerapps/features/data/product_remote_data_source.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/routes/constants.dart';
import '../cubit/product/product_cubit.dart';
import '../provider/cart_provider.dart';
import '../provider/control_bluetooth_provider.dart';
import '../widget/control_screen_list_tile.dart';
import 'bluetooth/device_list.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothDevice? server;

  ControlScreen({Key? key, this.server}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlScreenState();
}

class _ControlScreenState  extends State<ControlScreen>{
  // bool isOrdered = false;



  List<Permission> statuses = [
    Permission.bluetoothScan,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.location,
  ];
  Future<void> requestPermission() async {
    try {
      for (var element in statuses) {
        if ((await element.status.isDenied ||
            await element.status.isPermanentlyDenied)) {
          await statuses.request();
        }
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      await requestPermission();
    }
  }


  BluetoothDevice? get server => widget.server;
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;



  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;


  Future<void> _selectDateTime(BuildContext context, {required String lokerName}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DateTimePickerDialog(
          onConfirm: (DateTime start, TimeOfDay startT, DateTime end, TimeOfDay endT) {
            setState(() {
              startDate = start;
              startTime = startT;
              endDate = end;
              endTime = endT;
            });
          }, lokerName: lokerName,
        );
      },
    );
  }

  @override
  void initState(){
    context.read<ProductCubit>().getProductStatus();

    requestPermission();

    final bool bluetoothState = Provider.of<BluetoothControlStateProvider>(context, listen: false).isBluetooth;

    if (bluetoothState){

      BluetoothConnection.toAddress(server?.address).then((_connection) {
        print('Connected to the device');
        connection = _connection;
        setState(() {
          isConnecting = false;
          isDisconnecting = false;
        });
        CustomShowDialog.showCustomDialog(
            context,
            title: "Sukses",
            message: "Bluetooth berhasil terhubung",
            isCancel: false
        );
      }).catchError((error) {
        print('Cannot connect, exception occured');
        print(error);
        String errorMessage = 'Failed to connect to the device';
        if (error is PlatformException) {
          errorMessage = 'Cannot connect: ${error.message}';
        }
        //NOTES: Testing Purpose
        CustomShowDialog.showCustomDialog(
            context,
            title: "Connection Error",
            message: errorMessage,
            isCancel: false
        );
      //   showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: Text('Connection Error'),
      //           content: Text(errorMessage),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 AppRouter.router.pop();
      //               },
      //               child: Text('OK'),
      //             ),
      //           ],
      //         );
      //       });
      });
    }
    super.initState();
  }


  @override
  void dispose(){
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);


    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.grey.withOpacity(0.5),

            body: RefreshIndicator(
              onRefresh: () async {
                context.read<ProductCubit>().getProductStatus();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                child: Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                        child:Column(
                children: [
                  Image(
                      image: AssetImage('assets/images/loker_init.png'),
                      height: LHelperFunctions.screenHeight(context) * 0.15,
                  ),
                  SizedBox(height: 25),
                  ListLoker(),
                SizedBox(height: LHelperFunctions.screenHeight(context) * 0.05),
                  BluetoothButton(context)
                ]
                        ),
                          ),
              ),
            ),
    );
  }

  ElevatedButton BluetoothButton(BuildContext context) {
    return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        fixedSize: Size(LHelperFunctions.screenWidth(context) * 0.8, 50),
                        backgroundColor: LColors.secondary
                    ),
                    // onPressed: () {
                    //   ProductRemoteDataSource().getProductStatusStream().listen((products) {
                    //     print('All Products: $products');
                    //   });                  }
                    onPressed: () async {
                      final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SelectBondedDevicePage(checkAvailability: false);
                          },
                        ),
                      );

                      if (selectedDevice != null) {
                        print('Connect -> selected ' + selectedDevice.address);
                        Provider.of<BluetoothControlStateProvider>(context, listen: false)
                            .setSelectedDevice(selectedDevice);
                        _startChat(context, selectedDevice);

                      } else {
                        print('Connect -> no device selected');
                      }
                    }
                    , child: Text("Sambungkan Bluetooth",

                    style: TextStyle(fontFamily: 'Poppins',
                        color: LColors.white,
                        fontSize: 16),));
  }

  Container ListLoker() {
    return Container(
                  padding: EdgeInsets.all(1),
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ProductLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return CustomContainerListTile(
                              title: product['nama_loker'],
                              onPressedPesan: () {
                                _selectDateTime(context, lokerName: product['nama_loker']);
                                },
                              onPressedBuka: () {
                                if (isConnecting){
                                  CustomShowDialog.showCustomDialog(
                                      context,
                                      title: "Errpr",
                                      message: "Bluetooth belum tersambung",
                                      isCancel: false);
                                }
                                else {
                                _sendMessage(product['pesan_buka']);
                                }

                              },
                              onPressedTutup: () {
                                if (isConnecting){
                                  CustomShowDialog.showCustomDialog(
                                      context,
                                      title: "Error",
                                      message: "Bluetooth belum tersambung",
                                      isCancel: false
                                  );
                                } else {
                                _sendMessage(product['pesan_tutup']);
                                }
                              },
                              onPressedIcon: () {
                                AppRouter.router.go(Routes.historyScreenNamedPage, extra: product['nama_loker']);
                              },
                              isConnecting: isConnecting,
                              isOrdered: product['status'],
                            );
                            // return ListTile(
                            //   title: Text('Product ID: ${product['id']}'),
                            //   subtitle: Text('Status: ${product['status'] ? "Active" : "Inactive"}'),
                            // );
                          },
                        );
                      } else if (state is ProductError) {
                        return Center(child: Text(state.message));
                      }

                      return Center(child: Text('No Products Found'));
                    },
                  ),
                );
  }
  void _startChat(BuildContext context, BluetoothDevice server) {
    Provider.of<BluetoothControlStateProvider>(context, listen: false).setIsBluetooth(true);
    AppRouter.router.push(Routes.controlScreenNamedPage, extra: server);
    // Get.toNamed(Routes.homeNamedPage, arguments: server);
  }

  Future<void> _sendMessage(String text) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        print('Data:${text + "\n"}sent successfully');
      } catch (e) {
        print('Error sending data: $e');
        throw BluetoothConnectionException('Failed to send data: $e');

      }
    }
  }



}




class DateTimePickerDialog extends StatefulWidget {
  final Function(DateTime, TimeOfDay, DateTime, TimeOfDay) onConfirm;
  final String lokerName;

  DateTimePickerDialog({
    required this.onConfirm,
    required this.lokerName,
  });

  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
      _selectTime(context, isStartDate);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(

      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }
  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return intl.DateFormat('\nHH:mm \ndd, MMMM yyyy').format(dateTime);
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    return '$days hari, $hours jam, $minutes menit';
  }

  Duration? _calculateDuration(DateTime startDate, TimeOfDay startTime, DateTime endDate, TimeOfDay endTime) {
    final startDateTime = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
    final endDateTime = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
    return endDateTime.difference(startDateTime);
  }


  @override
  Widget build(BuildContext context) {
    Duration? duration;
    if (_startDate != null && _startTime != null && _endDate != null && _endTime != null) {
      duration = _calculateDuration(_startDate!, _startTime!, _endDate!, _endTime!);
    }
    return AlertDialog(
      title: Text('Pilih Jadwal Penyewaan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  fixedSize: Size(LHelperFunctions.screenWidth(context) * 0.8, 60),
                  backgroundColor: LColors.secondary
              ),
              onPressed: () => _selectDate(context, true),
              child: Text('Pilih Tanggal Mulai',
              style: TextStyle(fontFamily: 'Poppins',
            color: LColors.white,
            fontSize: 16),
              ),
            ),
            SizedBox(height: 15),
            _startDate != null && _startTime != null
                ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: LColors.white,
              ),
              child: Text(
                'Mulai: ${_formatDateTime(_startDate!, _startTime!)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            )
                : SizedBox(),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  fixedSize: Size(LHelperFunctions.screenWidth(context) * 0.8, 60),
                  backgroundColor: LColors.secondary
              ),
              onPressed: () => _selectDate(context, false),
              child: Text('Pilih Tanggal Akhir',
                  style: TextStyle(fontFamily: 'Poppins',
                      color: LColors.white,
                      fontSize: 16)),
            ),
            SizedBox(height: 15),
            _endDate != null && _endTime != null
                ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: LColors.white,
              ),
              child: Text(
                'Akhir: ${_formatDateTime(_endDate!, _endTime!)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            )
                : SizedBox(),
            SizedBox(height: 15),
            duration != null
                ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: LColors.white,
              ),
              child: Text(
                'Durasi Penyewaan Anda:\n ${_formatDuration(duration)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: LColors.black,
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (_startDate != null && _startTime != null && _endDate != null && _endTime != null) {
              widget.onConfirm(_startDate!, _startTime!, _endDate!, _endTime!);
              final cart = Provider.of<CartProvider>(context, listen: false);
              cart.addItem(
                widget.lokerName, // Provide a name for the item
                DateTime(_startDate!.year, _startDate!.month, _startDate!.day, _startTime!.hour, _startTime!.minute),
                DateTime(_endDate!.year, _endDate!.month, _endDate!.day, _endTime!.hour, _endTime!.minute),
              );
              Navigator.of(context).pop();
            }
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}


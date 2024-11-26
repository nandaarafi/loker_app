import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:go_router/go_router.dart';
import 'package:lokerapps/core/routes/constants.dart';
import 'package:provider/provider.dart';

import '../../features/presentation/provider/control_bluetooth_provider.dart';



class HomeScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const HomeScaffoldWithNavBar({
    required this.child,
    super.key,
  });
  final Widget child;


  @override
  Widget build(BuildContext context) {
    final BluetoothDevice? server = Provider.of<BluetoothControlStateProvider>(context, listen: false).selectedDevice;

    return PopScope(
      canPop: true,
      onPopInvoked: (didpop){
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.pest_control_rodent_outlined),
              label: 'Kontrol',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.shop),
              label: 'Order',
            ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context, server),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(Routes.controlScreenNamedPage)) {
      return 0;
    }
    if (location.startsWith(Routes.orderScreenNamedPage)) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, BluetoothDevice? server) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(Routes.controlScreenNamedPage, extra: server);
      case 1:
        GoRouter.of(context).go(Routes.orderScreenNamedPage);
    }
  }
}
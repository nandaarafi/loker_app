import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:go_router/go_router.dart';
import 'package:lokerapps/features/domain/order_data_model.dart';
import 'package:lokerapps/features/presentation/screen/control_screen.dart';
import 'package:lokerapps/features/presentation/screen/history_screen.dart';
import 'package:lokerapps/features/presentation/screen/sign_in_screen.dart';
import 'package:lokerapps/features/presentation/screen/sign_up_screen.dart';
import 'package:lokerapps/features/presentation/screen/success_screen.dart';
import 'package:lokerapps/features/presentation/screen/test_screen.dart';

import '../../features/presentation/screen/payment_screen.dart';
import '../../features/presentation/screen/payment_web_view_screen.dart';
import '../errors/routes_error.dart';
import 'constants.dart';
import 'home_nav_bar_screen.dart';


class AppRouter {

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');


  // static final GoRouter _router = GoRouter(
  //   initialLocation: Routes.testScreenNamedPage,
  //   debugLogDiagnostics: true,
  //   navigatorKey: _rootNavigatorKey,
  //   routes: [
  //
  //     GoRoute(
  //         path: Routes.testScreenNamedPage,
  //         builder: (BuildContext context, GoRouterState state) =>  TestScreen()
  //     ),


  static final GoRouter _router = GoRouter(
    // initialLocation: Routes.controlScreenNamedPage,
    initialLocation: Routes.rootSignInNamedPage,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [

      GoRoute(
          path: Routes.rootSignInNamedPage,
          builder: (BuildContext context, GoRouterState state) =>  SignInScreen()
      ),

      GoRoute(
          path: Routes.signUpNamedPage,
          builder: (BuildContext context, GoRouterState state) => SignUpScreen()
      ),
      GoRoute(
        path: Routes.historyScreenNamedPage,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String bucketName = state.extra as String;
          return NoTransitionPage(
            child: HistoryScreen(bucketName: bucketName),
          );
        },
      ),



      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return HomeScaffoldWithNavBar(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: Routes.controlScreenNamedPage,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final BluetoothDevice? server = state.extra as BluetoothDevice?;
                return NoTransitionPage(
                  child: ControlScreen(server: server),
                );
              },
            ),
            GoRoute(
                path: Routes.orderScreenNamedPage,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (BuildContext context, GoRouterState state){
                  return NoTransitionPage(
                      child: PaymentScreen());
                }
            ),
            GoRoute(
              path: Routes.bluetoothControlScreenNamedPage,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final BluetoothDevice? server = state.extra as BluetoothDevice?;
                return NoTransitionPage(
                  child: ControlScreen(server: server),
                );
              },
            ),

            GoRoute(
              path: Routes.testScreenNamedPage,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final BluetoothDevice? server = state.extra as BluetoothDevice?;
                return NoTransitionPage(
                  child: TestScreen(server: server),
                );
              },
            ),
          ]
      ),

      // GoRoute(
      //     path: Routes.orderScreenNamedPage,
      //     builder: (BuildContext context, GoRouterState state) => PaymentScreen()
      // ),
      // GoRoute(
      //     path: Routes.controlScreenNamedPage,
      //     builder: (BuildContext context, GoRouterState state) => PaymentScreen()
      // ),

      GoRoute(
        path: Routes.paymentScreenNamedPage,
        builder: (BuildContext context, GoRouterState state) {
          final TransactionResponse args = state.extra as TransactionResponse;
          return PaymentWebViewScreen(
             response: args,
          );
        },
      ),
      GoRoute(
          path: Routes.successScreenNamedPage,
          builder: (BuildContext context, GoRouterState state) => SuccessScreen()
      ),

    ],
    errorBuilder: (context, state) => const NotFoundScreen(),

  );

  static GoRouter get router => _router;
}


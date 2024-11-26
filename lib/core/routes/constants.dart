import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../errors/routes_error.dart';

class Routes {
  static const rootSignInNamedPage = '/sign-in';
  static const signUpNamedPage = '/sign-up';
  static const controlScreenNamedPage = '/control';
  static const orderScreenNamedPage = '/order';
  static const paymentScreenNamedPage = '/payment';
  static const successScreenNamedPage = '/sucess';
  static const testScreenNamedPage = '/test';
  static const historyScreenNamedPage = '/history';
  static const bluetoothControlScreenNamedPage = '/bluetooth-control';
  // static const heartRateNamedPage = '/heart-rate';
  // static const locationNamedPage = '/location';
  // static const controlNamedPage = '/control';
  // static const schedulerAlarmNamedPage = '/alarm';
  // static const loadingNamedPage = '/loading';


  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundScreen();
}
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokerapps/features/data/order_remote_data_source.dart';
import 'package:lokerapps/features/presentation/cubit/image/image_cubit.dart';
import 'package:lokerapps/features/presentation/cubit/product/product_cubit.dart';
import 'package:lokerapps/features/presentation/provider/cart_provider.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:provider/provider.dart';

import 'core/routes/routes.dart';
import 'core/theme/theme.dart';
import 'features/data/history_remote_data_source.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/order/order_cubit.dart';
import 'features/presentation/provider/control_bluetooth_provider.dart';
import 'features/presentation/provider/password_vis_provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothControlStateProvider()),
      ],
      child:  MyApp()));
}



class MyApp extends StatelessWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp>{
//   MidtransSDK? _midtrans;
//
//   @override
//   void initState() {
//     super.initState();
//     initSDK();
//   }
//
//   void initSDK() async {
//     _midtrans = await MidtransSDK.init(
//       config: MidtransConfig(
//         clientKey: "SB-Mid-client-DU2SB1A1-tk2YCVc",
//         merchantBaseUrl: "https://us-central1-loker-apps.cloudfunctions.net",
//         colorTheme: ColorTheme(
//           colorPrimary: Theme.of(context).colorScheme.secondary,
//           colorPrimaryDark: Theme.of(context).colorScheme.secondary,
//           colorSecondary: Theme.of(context).colorScheme.secondary,
//         ),
//       ),
//     );
//     _midtrans?.setUIKitCustomSetting(
//       skipCustomerDetailsPages: true,
//     );
//     _midtrans!.setTransactionFinishedCallback((result) {
//       print(result.toJson());
//     });
//   }
//   @override
//   void dispose(){
//     _midtrans?.removeTransactionFinishedCallback();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             child: Text("Pay Now"),
//             onPressed: () async {
//               try {
//                 String transactionToken = await OrderRemoteDataSource().createTransaction();
//                 _midtrans?.startPaymentUiFlow(token: transactionToken);
//               } catch (e) {
//                 print('Error: $e');
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => OrderCubit(OrderRemoteDataSource())),
        BlocProvider(create: (context) => ImageCubit(HistoryRemoteDataSource())),
        // BlocProvider(create: (context) => ProductStreamCubit ()),
      ],
      child:
      MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: LTheme.lightTheme,
        routerConfig: AppRouter.router,

        // navigatorKey: AppRouter.navigatorKey,
        // routerConfig: AppRouter.router,
        // routerDelegate: AppRouter.router.routerDelegate,
        // routeInformationParser: AppRouter.router.routeInformationParser,
      ),
    );
  }
}
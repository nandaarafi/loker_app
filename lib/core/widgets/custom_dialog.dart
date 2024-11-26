import 'package:flutter/material.dart';
import 'package:lokerapps/core/constants/colors.dart';

import '../routes/routes.dart';

class CustomShowDialog {
  static void showCustomDialog(BuildContext context,
      {
        required String title,
        required String message,
        required bool isCancel
      }) { showDialog(
    routeSettings: RouteSettings(),
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
        child: AlertDialog(

          title: Text(title),
          content: Text(message),
          actions: [
            //Is Cancel Button
            isCancel
                ? TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            )
                : SizedBox.shrink(),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    },
  );
  }

  static void showOnPressedDialog(BuildContext context,
      {
        required String title,
        required String message,
        required bool isCancel,
        required VoidCallback onPressed
      }) { showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            //Is Cancel Button
            isCancel
                ? TextButton(
              onPressed: () {
                // AppRouter.router.pop();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            )
                : SizedBox.shrink(),

            TextButton(
              onPressed: onPressed,
              child: Text('OK'),
            ),
          ],
        ),
      );
    },
  );
  }
}

class CustomDialogClass extends StatelessWidget {
  final String title;
  final String message;
  final bool isCancel;
  const CustomDialogClass({
    Key? key,
    required this.title,
    required this.message,
    this.isCancel = false, // Default value for isCancel
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        //Is Cancel Button
        isCancel
            ? TextButton(
          onPressed: () {
            AppRouter.router.pop(); // Close the dialog
          },
          child: Text('Cancel'),
        )
            : SizedBox.shrink(),

        TextButton(
          onPressed: () {
            AppRouter.router.pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
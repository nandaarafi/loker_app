//TODO: make a widget for isOrdered and non
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/helper/helper_functions.dart';
class CustomContainerListTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressedPesan;
  final VoidCallback onPressedBuka;
  final VoidCallback onPressedTutup;
  final VoidCallback onPressedIcon;
  final bool isConnecting;
  final bool isOrdered;
  // final bool isDipesan;
  const CustomContainerListTile({
    super.key, required this.title,
    required this.onPressedPesan,
    required this.onPressedIcon,
    required this.onPressedBuka,
    required this.onPressedTutup,
    required this.isConnecting,
    required this.isOrdered,
    // required this.isDipesan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      // height: LHelperFunctions.screenHeight(context) * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: LColors.white
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

                  Text(title,
                    style: TextStyle(fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
                  ),
                  // Text("")


              ElevatedButton(
                onPressed: onPressedPesan,
                child: Text(
                  "Pesan",
                  style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: LColors.grey),
              ),

              IconButton(onPressed: onPressedIcon, icon: Icon(
                  Icons.history
              ))
            ],

          ),
          isOrdered ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            ElevatedButton(
              onPressed: onPressedBuka,
              child: Text(
                "Buka",
                style: TextStyle(
                    color:
                    isConnecting ? Colors.white : Colors.black
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: LColors.grey),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: onPressedTutup,
              child: Text(
                "Tutup",
                style: TextStyle(
                    color:
                    isConnecting ? Colors.white : Colors.black
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: LColors.grey),
            ),
          ],
          )
            : SizedBox()
          ,

        ],
      ),
    );
  }

}



class CustomContainerListTile2 extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  CustomContainerListTile2({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
        color: LColors.white
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w800),),
                  Text(subtitle, overflow: TextOverflow.clip,),
              
              
                ],
                // title: Text(title),
                // subtitle: Text(subtitle),
                // trailing: IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: onPressed,
                // ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onPressed,
            ),
          ],

        ),
      ),
    );
  }
}
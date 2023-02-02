import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'all_resources.dart';

final kTextInputDecoration = InputDecoration(
  // labelStyle: TextStyle(
  //   color: ColorManager.indyBlue,
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: ColorManager.indyBlue, width: 1.5),
  //   borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
  // ),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: ColorManager.indyBlue, width: 1.5),
  //   borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
  // ),
  // errorBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.red, width: 1.5),
  //   borderRadius: BorderRadius.all(
  //     Radius.circular(Sizes.dimen_10),
  //   ),
  // ),
  // focusedErrorBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.red, width: 1.5),
  //   borderRadius: BorderRadius.all(
  //     Radius.circular(Sizes.dimen_10),
  //   ),
  // ),

  filled: true,
  errorStyle: TextStyle(height: 0, color: ColorManager.parent),
  hintStyle: getRegularStyle(
      color: ColorManager.black.withOpacity(0.4), fontSize: FontSize.s16.sp),
  fillColor: ColorManager.white,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(7),
      topRight: Radius.circular(7),
      bottomRight: Radius.circular(7),
      bottomLeft: Radius.circular(7),
    ),
    borderSide: BorderSide(color: ColorManager.peerMessagesColor, width: 1),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(7),
      topRight: Radius.circular(7),
      bottomRight: Radius.circular(7),
      bottomLeft: Radius.circular(7),
    ),
    borderSide: BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(7),
      topRight: Radius.circular(7),
      bottomRight: Radius.circular(7),
      bottomLeft: Radius.circular(7),
    ),
    borderSide: BorderSide(color: Colors.red),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(7),
      topRight: Radius.circular(7),
      bottomRight: Radius.circular(7),
      bottomLeft: Radius.circular(7),
    ),
    borderSide: BorderSide(
      color: ColorManager.myMessagesColor,
    ),
  ),
);

const Widget vertical5 = SizedBox(height: 5.0);
const Widget vertical10 = SizedBox(height: 10.0);
const Widget vertical15 = SizedBox(height: 15.0);
const Widget vertical20 = SizedBox(height: 20.0);

const Widget vertical25 = SizedBox(height: 25.0);
const Widget vertical30 = SizedBox(height: 30.0);

const Widget vertical50 = SizedBox(height: 50.0);
const Widget vertical120 = SizedBox(height: 120.0);

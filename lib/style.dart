import 'package:flutter/material.dart';

const brandTextStyle = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

final addButtonStyle = ([Color? color]) => BoxDecoration(
    color: color ?? Color(0xFF18A0FB), borderRadius: BorderRadius.circular(12));

const addButtonLabelStyle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF));

final longPressHelpMessageStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Color(0x00000000).withOpacity(0.6),
);

const fontItemStyle = BoxDecoration(
    // hei
    // color: Color(0xFFE0F4FE)
    );

const fontPreviewTitleStyle = TextStyle(
  fontSize: 28
);

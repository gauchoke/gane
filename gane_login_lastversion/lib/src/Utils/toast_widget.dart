import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';

class ToastWidget extends StatelessWidget {

  final String description;
  const ToastWidget({required this.description});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: CustomColors.black,
                borderRadius: BorderRadius.all(const Radius.circular(20))),
            child: Text(description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.key,
                    fontSize: 13,
                    color: CustomColors.white))),
          ),
      ),
    );
  }

}

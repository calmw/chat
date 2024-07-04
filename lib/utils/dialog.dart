import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrDialog {
  showBottomSelectDialog(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        isScrollControlled: true,
        enableDrag: false,
        constraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity),
        builder: (context) => child);
  }

  showBottomMsg(BuildContext context, String msg) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        isScrollControlled: true,
        enableDrag: false,
        constraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity),
        builder: (context) => SizedBox(
              height: 150,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 65,),
                  Text(msg, style: const TextStyle(fontSize: 22))
                ],
              ),
            ));
  }
}

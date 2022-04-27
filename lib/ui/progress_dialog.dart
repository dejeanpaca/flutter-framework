import 'package:flutter/material.dart';

Future<void> showProgressDialog(BuildContext context, Future future,
    {bool dismissible = false, Widget? content, String? message = 'Please wait ...', ShapeBorder? dialogShape}) async {
  await showDialog(
    context: context,
    builder: (context) =>
        ProgressDialog(
          future,
          content: content,
          message: message,
          shape: dialogShape,
        ),
    barrierDismissible: dismissible,
  );
}

class ProgressDialog extends StatefulWidget {
  @required
  final Future future;

  final Widget? content;
  final String? message;

  final ShapeBorder? shape;
  final EdgeInsets insetPadding;

  ProgressDialog(this.future, {this.message, this.content, this.shape, this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0, vertical: 24.0)});

  @override
  State<StatefulWidget> createState() => ProgressDialogState();
}

class ProgressDialogState extends State<ProgressDialog> {
  bool futureHooked = false;

  @override
  Widget build(BuildContext context) {
    if (!futureHooked) {
      futureHooked = true;

      widget.future.then((value) {
        Navigator.pop(context);
      }).catchError((o, stackTrace) {
        print('Error during progress ${0.toString()} dialog:\n' + stackTrace.toString());
        Navigator.pop(context);
      });
    }

    return WillPopScope(
      child: buildDialog(context),
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
    );
  }

  Widget buildDialog(BuildContext context) {
    var shape = widget.shape != null ? widget.shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

    Widget content = widget.content != null
        ? widget.content!
        : Center(
      heightFactor: 1.0,
      child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),
            const Padding(padding: const EdgeInsets.only(right: 10.0),),
            if (widget.message != null) Expanded(child: Text(widget.message!)),
          ])),
    );

    return Dialog(child: content, shape: shape, insetPadding: widget.insetPadding);
  }
}

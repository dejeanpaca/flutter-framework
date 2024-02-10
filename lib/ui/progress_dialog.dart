import 'package:flutter/material.dart';

Future<void> showProgressDialog(BuildContext context, Future<dynamic> future,
    {bool dismissible = false, Widget? content, String? message, ShapeBorder? dialogShape}) async {
  message ??= ProgressDialog.defaultMessage;

  await showDialog(
    context: context,
    useSafeArea: true,
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

Future<void> showProgressDialogNavigator(NavigatorState navigator, Future<void> future,
    {bool dismissible = false, Widget? content, String? message, ShapeBorder? dialogShape}) async {
  if (navigator.mounted) {
    return showProgressDialog(navigator.context, future,
        dismissible: dismissible, content: content, message: message, dialogShape: dialogShape);
  } else {
    return future;
  }
}


class ProgressDialog extends StatefulWidget {
  static String defaultMessage = 'Please wait ...';
  static TextStyle? textStyle = TextStyle(fontSize: 18);
  static Color? indicatorColor = Colors.blueAccent;

  @required
  final Future future;

  final Widget? content;
  final String? message;

  final ShapeBorder? shape;
  final EdgeInsets insetPadding;

  const ProgressDialog(this.future, {
    Key? key,
    this.message,
    this.content,
    this.shape,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  }) : super(key: key);

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
      }).catchError((err, stackTrace) {
        debugPrint('Error during progress ${err.toString()} dialog');
        debugPrintStack(stackTrace: stackTrace);
        Navigator.pop(context);
      });
    }

    return PopScope(
      child: buildDialog(context),
      canPop: false,
    );
  }

  Widget buildDialog(BuildContext context) {
    var shape = widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

    Widget content = widget.content != null
        ? widget.content!
        : Center(
      heightFactor: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              color: ProgressDialog.indicatorColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
          ),
          if (widget.message != null)
            Expanded(child:
            Text(widget.message!, style: ProgressDialog.textStyle),
            ),
        ]),
      ),
    );

    return Dialog(shape: shape, insetPadding: widget.insetPadding, child: content);
  }
}

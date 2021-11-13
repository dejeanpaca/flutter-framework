import 'package:flutter/material.dart';

class Respawn extends StatefulWidget {
  final Widget child;

  Respawn({Key? key, required this.child}) : super(key: key);

  @override
  _RespawnState createState() => _RespawnState();

  static respawn(BuildContext context) {
    context.findAncestorStateOfType<_RespawnState>()!.respawn();
  }
}

class _RespawnState extends State<Respawn> {
  Key _key = UniqueKey();

  void respawn() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
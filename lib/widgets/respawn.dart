import 'package:flutter/material.dart';

class Respawn extends StatefulWidget {
  final Widget child;

  const Respawn({super.key, required this.child});

  @override
  RespawnState createState() => RespawnState();

  static respawn(BuildContext context) {
    context.findAncestorStateOfType<RespawnState>()!.respawn();
  }
}

class RespawnState extends State<Respawn> {
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
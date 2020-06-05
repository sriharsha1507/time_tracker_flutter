import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      this.cancelActionText,
      @required this.defaultActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog<bool>(context: context, builder: (context) => this);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _buildActions(context),
      );

  @override
  Widget buildMaterialWidget(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _buildActions(context),
      );

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) => CupertinoDialogAction(
        child: child,
        onPressed: onPressed,
      );

  @override
  Widget buildMaterialWidget(BuildContext context) => FlatButton(
        child: child,
        onPressed: onPressed,
      );
}

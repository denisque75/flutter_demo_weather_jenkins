import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle kDefaultAppDialogTitleStyle = const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w700,
  height: 1.1,
  color: Colors.black,
);

TextStyle kDefaultAppDialogTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
  color: Colors.black.withOpacity(0.5),
);

TextStyle kDefaultAppDialogButtonTextStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

class AppDialogAction extends StatelessWidget {
  const AppDialogAction({
    required this.onPressed,
    required this.text,
    this.textColor,
    this.backgroundColor,
  });

  factory AppDialogAction.primary({
    required VoidCallback onPressed,
    required Widget text,
  }) =>
      AppDialogAction(
        onPressed: onPressed,
        text: text,
        textColor: Colors.white,
        backgroundColor: Colors.black,
      );

  factory AppDialogAction.secondary({
    required VoidCallback onPressed,
    required Widget text,
  }) =>
      AppDialogAction(
        onPressed: onPressed,
        text: text,
        textColor: Colors.black,
        backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
      );

  final VoidCallback onPressed;
  final Widget text;
  final Color? textColor;
  final Color? backgroundColor;

  static const RoundedRectangleBorder _defaultButtonShape =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: _defaultButtonShape,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          primary: textColor,
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: text,
      ),
    );
  }
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key? key,
    required this.content,
    this.contentPadding = const EdgeInsets.only(
      top: 40,
      left: 24,
      right: 24,
      bottom: 24,
    ),
    this.elevation = 16.0,
    this.contentBorderRadius = 12.0,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 1),
  }) : super(key: key);

  final Widget content;
  final EdgeInsets contentPadding;
  final double? elevation;
  final double contentBorderRadius;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final ShapeBorder? shape;
  final Color? backgroundColor;

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(2.0),
    ),
  );
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0, minHeight: 0.0),
            child: Material(
              color: backgroundColor ??
                  dialogTheme.backgroundColor ??
                  Theme.of(context).dialogBackgroundColor,
              elevation:
                  elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    padding: contentPadding,
                    child: content,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    Key? key,
    this.icon,
    this.title,
    required this.text,
    this.actions = const [],
  }) : super(key: key);

  final Widget? icon;
  final Widget? title;
  final Widget text;
  final List<AppDialogAction> actions;

  Widget _dialogIcon(Widget icon) {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(248, 248, 250, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(24.0),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) _dialogIcon(icon!),
          if (title != null) title!,
          text,
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            )
        ],
      ),
    );
  }
}

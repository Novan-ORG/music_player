// This helper keeps modal-sheet dismissal behavior explicit in one place.
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = false,
  bool showDragHandle = false,
  Color? backgroundColor,
  ShapeBorder? shape,
  Clip? clipBehavior,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: backgroundColor,
    shape: shape,
    clipBehavior: clipBehavior,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

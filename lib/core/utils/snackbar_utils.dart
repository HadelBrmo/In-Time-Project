 import 'package:flutter/material.dart';

class SnackBarUtils {
static void showSuccess(BuildContext context, String message, {SnackBarAction? action}) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
message,
style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
textAlign: TextAlign.right,
),
backgroundColor: Colors.green,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
duration: const Duration(seconds: 3),
action: action,
),
);
}

static void showError(BuildContext context, String message, {SnackBarAction? action, Duration duration = const Duration(seconds: 4)}) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
message,
style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
textAlign: TextAlign.right,
),
backgroundColor: Colors.redAccent,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
duration: duration,
action: action,
),
);
}

static void showWarning(BuildContext context, String message, {SnackBarAction? action}) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
message,
style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
textAlign: TextAlign.right,
),
backgroundColor: Colors.orangeAccent,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
duration: const Duration(seconds: 3),
action: action,
),
);
}
}
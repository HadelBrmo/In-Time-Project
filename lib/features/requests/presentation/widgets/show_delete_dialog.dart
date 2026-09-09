import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';

void showDeleteDialog(BuildContext context, int requestId) {
  DialogUtils.showConfirmDialog(
    context: context,
    title: 'حذف الطلب',
    message: 'هل أنت متأكد من أنك تريد حذف هذا الطلب نهائياً؟',
    confirmText: 'حذف',
    confirmColor: Colors.red,
    onConfirm: () {
      context.read<RequestsBloc>().add(DeleteRequestEvent(requestId: requestId));
    },
  );
}
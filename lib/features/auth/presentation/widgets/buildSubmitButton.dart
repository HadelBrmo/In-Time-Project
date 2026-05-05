import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/SignUpBloc/sign up_bloc.dart';
import '../bloc/SignUpEvent/sign up_event.dart';

Widget buildSubmitButton(BuildContext context, MediaQueryHelper media) {
  return Center(
    child: CustomButton(
      text: "التالي",
      width: media.width * 0.65,
      height: 55,
      fontSize: 18,
      onPressed: () {
        context.read<SignUpBloc>().add(SubmitSignUpEvent());
      },
    ),
  );
}
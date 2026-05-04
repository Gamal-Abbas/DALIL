import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Forggetpassword extends StatelessWidget {
  final String email;
  const Forggetpassword({super.key, required this.email, });

  @override
  Widget build(BuildContext context) {
    // final SH = MediaQuery.of(context).size.height;
    print('Forggetpassword==============');
    return GestureDetector(
      onTap: () async {
        // final a=
        await context.read<authBloc>().handleResetPassword(
          context: context,
          email: email,
        );
      },
      child: Customtext(
        weight: FontWeight.w400,
        text: 'forgetPassword'.tr(),
        size: (context.screenHeight / 40).clamp(16, 30),
        color: AppColors.secondaryDark,
      ),
    );
  }
}

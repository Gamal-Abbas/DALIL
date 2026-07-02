import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';
import '../manager/authBloc.dart';

class Forggetpassword extends StatelessWidget {
  final String email;

  const Forggetpassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    print('Forggetpassword==============');
    return GestureDetector(
      onTap: () async {
        resetPasswordTap(context);
      },
      child: Customtext(
        weight: FontWeight.w400,
        text: 'forgetPassword'.tr(),
        size: (context.screenHeight / 40).clamp(16, 30),
        color: context.primary,
      ),
    );
  }

  Future<void> resetPasswordTap(BuildContext context)async{
    await context.read<authBloc>().resetPassword(email: email);

  }
}
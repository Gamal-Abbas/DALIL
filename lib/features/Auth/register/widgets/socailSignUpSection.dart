import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/features/Auth/register/widgets/SignMethode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class socialSignUpSection extends StatelessWidget {
  const socialSignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: (context.screenHeight / 20),
      children: [
        Row(
          children: [
           const Expanded(
              child: Divider(color: AppColors.primaryLight, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Customtext(
                text: 'orSignupWith'.tr(),
                size: (context.screenHeight / 50).clamp(14, 30),
                color: AppColors.thirdDark,
                weight: FontWeight.w400,
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.primaryLight, thickness: 1),
            ),
          ],
        ),

        Signmethode(
          googleontap: () async {
            await context.read<authBloc>().signInWithGoogle();
          },
          facebookontap: () {},
          appleontap: () {},
        ),
      ],
    );
  }
}

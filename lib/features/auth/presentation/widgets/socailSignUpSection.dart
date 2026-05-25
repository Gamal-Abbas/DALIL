import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';
import '../manager/authBloc.dart';
import 'SignMethode.dart';

class socialSignUpSection extends StatelessWidget {
  const socialSignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: (context.screenHeight / 20),
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: context.cardColor, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Customtext(
                text: 'orSignupWith'.tr(),
                size: (context.screenHeight / 50).clamp(14, 30),
                color: context.textHint,
                weight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Divider(color: context.cardColor, thickness: 1),
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
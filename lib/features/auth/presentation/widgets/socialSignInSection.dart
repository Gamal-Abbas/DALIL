import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/size.dart';
import '../../../../customWidgets/customText.dart';
import '../manager/authBloc.dart';
import 'SignMethode.dart';

class socialSignInSection extends StatelessWidget {
  const socialSignInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Customtext(
          weight: FontWeight.w400,
          text: 'orSignInWith'.tr(),
          size: (context.screenHeight / 50).clamp(14, 35),
          color: context.textHint,
        ),
        Gap(context.screenHeight / 80),
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
import 'package:dalil/core/bloc/auth/authBloc.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/core/utils/size.dart';
import 'package:dalil/customWidgets/customText.dart';
import 'package:dalil/features/Auth/register/widgets/SignMethode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class socialSignInSection extends StatelessWidget {
  const socialSignInSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final SH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Customtext(
          weight: FontWeight.w400,
          text: 'orSignInWith'.tr(),
          size: (context.screenHeight / 50).clamp(14, 35),
          color: AppColors.thirdDark,
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

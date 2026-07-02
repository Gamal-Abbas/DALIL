import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_color.dart';

class DescriptionSection extends StatefulWidget {
  final String description;
  final bool showFull;
  final VoidCallback onToggle;
  final Color gold;
  final double fontSizeTitle;
  final double fontSizeBody;
  final double fontSizeSeeMore;
  final double gapHeight;
  final double height;

  const DescriptionSection({
    super.key,
    required this.description,
    required this.showFull,
    required this.onToggle,
    required this.gold,
    required this.fontSizeTitle,
    required this.fontSizeBody,
    required this.fontSizeSeeMore,
    required this.gapHeight,
    required this.height,
  });

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  final ValueNotifier<bool> _showFullNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    print('build    description section  =======================');

    return ValueListenableBuilder<bool>(
      valueListenable: _showFullNotifier,
      builder: (context, showFull, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "historical_eras".tr(),
              style: TextStyle(
                fontSize: widget.fontSizeTitle, //14
                color: widget.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(widget.gapHeight),

            ///15
            Text(
              widget.description.isEmpty
                  ? "no_description_available".tr()
                  : widget.description,
              maxLines: showFull ? null : 4,
              overflow: showFull ? null : TextOverflow.ellipsis,
              style: TextStyle(
                // color: Colors.white.withOpacity(0.8),
                color: AppColors.white_with_opacity_08,
                fontSize: widget.fontSizeBody, //16
                height: (widget.height / 520).clamp(1.6, 2), //1.6
              ),
            ),

            if (widget.description.length > 150)
              GestureDetector(
                onTap: () {
                  // widget.onToggle();
                  _showFullNotifier.value = !_showFullNotifier.value;
                  // _showFullNotifier.value = !showFull;
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: widget.height / 100)
                      .clamp(
                        EdgeInsetsGeometry.symmetric(vertical: 8),
                        EdgeInsetsGeometry.symmetric(vertical: 12),
                      ),
                  child: Text(
                    !showFull ? "seeMore".tr() : "seeLess".tr(),
                    style: TextStyle(
                      fontSize: widget.fontSizeSeeMore, //14
                      color: widget.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

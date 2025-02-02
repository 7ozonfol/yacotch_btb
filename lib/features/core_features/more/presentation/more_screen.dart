import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainee_restaurantapp/core/localization/language_helper.dart';
import 'package:trainee_restaurantapp/features/core_features/more/presentation/account_setting/section.dart';
import 'package:trainee_restaurantapp/features/core_features/more/presentation/app_setting/app_setting.dart';
import 'package:trainee_restaurantapp/features/core_features/more/presentation/widgets/chip.dart';
import '../../../../../core/common/style/gaps.dart';
import '../../../../../core/ui/widgets/custom_appbar.dart';
import '../../../../../core/ui/widgets/title_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key, required this.data, required this.typeUser})
      : super(key: key);
  final List<MoreChipEntity> data;
  final int typeUser;
  @override
  Widget build(BuildContext context) {
    var tr = LanguageHelper.getTranslation(context);
    return Scaffold(
      appBar: TransparentAppBar(title: tr.more),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(title: tr.goto),
              Gaps.vGap16,
              //data
              ListView.builder(
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => MoreCustomChipWidget(
                  entity: data[index],
                ),
              ),
              AccountSettingWidget(typeUser),
              const MoreAppSetting(),
              Gaps.vGap30,
            ],
          ),
        ),
      ),
    );
  }
}

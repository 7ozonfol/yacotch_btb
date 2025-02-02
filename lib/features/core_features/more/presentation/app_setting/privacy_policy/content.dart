import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainee_restaurantapp/core/common/style/gaps.dart';
import 'package:trainee_restaurantapp/core/constants/app/app_constants.dart';
import 'package:trainee_restaurantapp/core/ui/widgets/blur_widget.dart';
import 'package:trainee_restaurantapp/core/ui/widgets/custom_text.dart';
import 'package:trainee_restaurantapp/features/core_features/more/controller/more_cubit.dart';

class PrivacyPolicyScreenContent extends StatefulWidget {
  @override
  State<PrivacyPolicyScreenContent> createState() =>
      _PrivacyPolicyScreenContentState();
}

class _PrivacyPolicyScreenContentState
    extends State<PrivacyPolicyScreenContent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()..getPrivacyPolicy(),
      lazy: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Gaps.vGap16,
              Image.asset(
                AppConstants.APP_LOGO_IMG,
                width: 117.w,
                fit: BoxFit.contain,
              ),
              Gaps.vGap40,
              const _Content()
            ],
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(builder: (context, state) {
      return BlurWidget(
        width: 1.sw,
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: CustomText(
            text: state is PrivacyPolicyLoaded ? state.data : "",
            fontSize: AppConstants.textSize16,
            textAlign: TextAlign.center,
            height: 2.h,
          ),
        ),
      );
    });
  }
}

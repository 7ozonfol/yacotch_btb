import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trainee_restaurantapp/core/common/validators.dart';
import 'package:trainee_restaurantapp/core/localization/language_helper.dart';
import '../../../../core/common/app_colors.dart';
import '../../../../core/common/style/dimens.dart';
import '../../../../core/common/style/gaps.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/ui/loader.dart';
import '../../../../core/ui/widgets/custom_appbar.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/models/shop_model.dart';
import '../shop_profile_controller/shop_profile_cubit.dart';

class EditShopScreenContent extends StatefulWidget {
  @override
  State<EditShopScreenContent> createState() => _EditShopScreenContentState();
}

class _EditShopScreenContentState extends State<EditShopScreenContent> {
  @override
  void initState() {
    ShopProfileCubit.of(context).getShopProfile(context);
    initControllers();
    super.initState();
  }

  initControllers() {
    ShopProfileCubit.of(context).imageNetwork =
        ShopProfileCubit.of(context).shopModel!.logo;
    ShopProfileCubit.of(context).nameArController.text =
        ShopProfileCubit.of(context).shopModel!.arName ?? '';
    ShopProfileCubit.of(context).nameEnController.text =
        ShopProfileCubit.of(context).shopModel!.enName ?? '';
    ShopProfileCubit.of(context).logoArNetwork =
        ShopProfileCubit.of(context).shopModel!.arLogo ?? '';
    ShopProfileCubit.of(context).logoEnNetwork =
        ShopProfileCubit.of(context).shopModel!.enLogo ?? '';
    ShopProfileCubit.of(context).coveArNetwork =
        ShopProfileCubit.of(context).shopModel!.arCover ?? '';
    ShopProfileCubit.of(context).coveEnNetwork =
        ShopProfileCubit.of(context).shopModel!.enCover ?? '';
    ShopProfileCubit.of(context).phoneController.text =
        ShopProfileCubit.of(context).shopModel!.phoneNumber ?? '';
   
    ShopProfileCubit.of(context).cityController.text =
        ShopProfileCubit.of(context).shopModel!.city!.text ?? '';
    ShopProfileCubit.of(context).streetController.text =
        ShopProfileCubit.of(context).shopModel!.street ?? '';
    ShopProfileCubit.of(context).buildNumController.text =
        ShopProfileCubit.of(context).shopModel!.buildingNumber ?? '';
    ShopProfileCubit.of(context).mangerController.text =
        ShopProfileCubit.of(context).shopModel!.manager!.name ?? '';
    ShopProfileCubit.of(context).facebookController.text =
        ShopProfileCubit.of(context).shopModel!.facebookUrl ?? '';
    ShopProfileCubit.of(context).instegramController.text =
        ShopProfileCubit.of(context).shopModel!.instagramUrl ?? '';
    ShopProfileCubit.of(context).twitterController.text =
        ShopProfileCubit.of(context).shopModel!.twitterUrl ?? '';
    ShopProfileCubit.of(context).websiteController.text =
        ShopProfileCubit.of(context).shopModel!.websiteUrl ?? '';
    ShopProfileCubit.of(context).descEnController.text =
        ShopProfileCubit.of(context).shopModel!.enDescription ?? '';
    ShopProfileCubit.of(context).descArController.text =
        ShopProfileCubit.of(context).shopModel!.arDescription ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var tr = LanguageHelper.getTranslation(context);
    return Scaffold(
      appBar: TransparentAppBar(
        title: Translation.of(context).edit_profile,
      ),
      body: BlocConsumer<ShopProfileCubit, ShopProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetShopProfileLoading) {
            return const Loader();
          } else {
            return Form(
              key: ShopProfileCubit.of(context).formKey,
              child: SizedBox(
                height: 1.sh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        // _buildImageWidget(
                        //     ShopProfileCubit
                        //         .of(context)
                        //         .file ?? File('')),
                        SizedBox(
                          height: 55.h,
                        ),
                        _buildTextFiledWidget(
                            type: TextInputType.name,
                            validator: (input) => !Validators.isArabic(input!)
                                ? tr.enter_at_letters
                                : null,
                            title: tr.shop_name_ar,
                            textEditingController:
                                ShopProfileCubit.of(context).nameArController),
                        Gaps.vGap24,
                        _buildTextFiledWidget(
                            type: TextInputType.name,
                            validator: (input) => !Validators.isEnglish(input!)
                                ? tr.enter_eng_letters
                                : null,
                            title: tr.shop_name_en,
                            textEditingController:
                                ShopProfileCubit.of(context).nameEnController),
                        Gaps.vGap24,
                        uploadSignUpFile(
                          text: tr.logo_ar,
                          file: ShopProfileCubit.of(context).fileLogoAr ??
                              File(''),
                          asset: AppConstants.AVATER_IMG,
                          image:
                              ShopProfileCubit.of(context).logoArNetwork ?? '',
                          onTap: () async {
                            await ShopProfileCubit.of(context).pickLogoAr();
                          },
                        ),
                        Gaps.vGap8,
                        uploadSignUpFile(
                          text: tr.logo_en,
                          file: ShopProfileCubit.of(context).fileLogoEn ??
                              File(''),
                          asset: AppConstants.AVATER_IMG,
                          image:
                              ShopProfileCubit.of(context).logoEnNetwork ?? '',
                          onTap: () async {
                            await ShopProfileCubit.of(context).pickLogoEn();
                          },
                        ),
                        Gaps.vGap8,
                        uploadSignUpFile(
                          text: tr.cover_en,
                          file: ShopProfileCubit.of(context).fileCoveEn ??
                              File(''),
                          image:
                              ShopProfileCubit.of(context).coveEnNetwork ?? '',
                          asset: AppConstants.COVER_IMG,
                          onTap: () async {
                            await ShopProfileCubit.of(context).pickCoverEn();
                          },
                        ),
                        Gaps.vGap8,
                        uploadSignUpFile(
                          text: tr.cover_ar,
                          file: ShopProfileCubit.of(context).fileCoveAr ??
                              File(''),
                          image:
                              ShopProfileCubit.of(context).coveArNetwork ?? '',
                          asset: AppConstants.COVER_IMG,
                          onTap: () async {
                            await ShopProfileCubit.of(context).pickCoverAr();
                          },
                        ),
                        Gaps.vGap24,
                        _buildTextFiledWidget(
                            type: TextInputType.number,
                            validator: (input) =>
                                Validators.isNumber(input!, context),
                            title: Translation.of(context).phone,
                            isPhoneNumber: true,
                            textEditingController:
                                ShopProfileCubit.of(context).phoneController),
                        Gaps.vGap24,
                        //_buildTextFiledWidget(
                        //    type: TextInputType.number,
                        //    validator: (input) =>
                        //        Validators.isNumber(input!, context),
                        //    title: tr.commericalNumber,
                        //    textEditingController: ShopProfileCubit.of(context)
                        //        .commercialRegisterNumberController),
                        //Gaps.vGap24,
                        //uploadSignUpFile(
                        //  text: tr.commericalFile,
                        //  file: ShopProfileCubit.of(context)
                        //          .fileCommercialRegisterDoc ??
                        //      File(''),
                        //  asset: '',
                        //  image: ShopProfileCubit.of(context)
                        //          .commercialRegisterDoc ??
                        //      '',
                        //  onTap: () async {
                        //    await ShopProfileCubit.of(context)
                        //        .pickCommericalDoc();
                        //  },
                        //   ),
                        Gaps.vGap8,
                        // _buildTextFiledWidget(
                        //     title: Translation
                        //         .of(context)
                        //         .cityName,
                        //     textEditingController:
                        //     ShopProfileCubit
                        //         .of(context)
                        //         .cityController),
                        // Gaps.vGap24,
                        // _buildTextFiledWidget(
                        //     title: "اسم الشارع",
                        //     textEditingController:
                        //     ShopProfileCubit
                        //         .of(context)
                        //         .streetController),
                        // Gaps.vGap24,
                        // _buildTextFiledWidget(
                        //     title: "رقم البناء",
                        //     textEditingController:
                        //     ShopProfileCubit
                        //         .of(context)
                        //         .buildNumController),
                        // Gaps.vGap24,
                        _buildTextFiledWidget(
                            type: TextInputType.name,
                            validator: (input) =>
                                !Validators.isNotEmptyString(input!)
                                    ? tr.errorEmptyField
                                    : null,
                            title: tr.shopManagerName,
                            textEditingController:
                                ShopProfileCubit.of(context).mangerController),
                        Gaps.vGap24,
                        _buildTextFiledWidget(
                            type: TextInputType.name,
                            validator: (input) => !Validators.isArabic(input!)
                                ? tr.enter_at_letters
                                : null,
                            title: tr.details_in_arabic,
                            textEditingController:
                                ShopProfileCubit.of(context).descArController),
                        Gaps.vGap24,
                        _buildTextFiledWidget(
                            type: TextInputType.name,
                            validator: (input) => !Validators.isEnglish(input!)
                                ? tr.enter_eng_letters
                                : null,
                            title: tr.details_in_english,
                            textEditingController:
                                ShopProfileCubit.of(context).descEnController),
                        Gaps.vGap24,
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                ShopProfileCubit.of(context)
                                    .onLocationClick(context);
                              },
                              child: CustomText(
                                text: tr.select_your_location,
                                color: AppColors.accentColorLight,
                                fontSize: AppConstants.textSize16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Gaps.vGap8,
                        _buildSocialMediaContainer(
                            title: tr.social_media_links,
                            controller:
                                ShopProfileCubit.of(context).facebookController,
                            icon: FontAwesomeIcons.squareFacebook),
                        _buildSocialMediaContainer(
                          title: "",
                          icon: FontAwesomeIcons.instagram,
                          controller:
                              ShopProfileCubit.of(context).instegramController,
                        ),
                        _buildSocialMediaContainer(
                          title: "",
                          icon: FontAwesomeIcons.twitter,
                          controller:
                              ShopProfileCubit.of(context).twitterController,
                        ),
                        _buildSocialMediaContainer(
                          title: "",
                          icon: FontAwesomeIcons.earth,
                          controller:
                              ShopProfileCubit.of(context).websiteController,
                        ),
                        Gaps.vGap24,
                        // _addWorkingHours(),
                        Gaps.vGap24,
                        SizedBox(
                          height: 44.h,
                          width: 217.w,
                          child: (state is UploadImageLoading)
                              ? const Center(child: CircularProgressIndicator())
                              : CustomElevatedButton(
                                  text: Translation.of(context).save,
                                  onTap: () {
                                    ShopProfileCubit.of(context)
                                        .updateShopProfile(context);
                                  },
                                  textSize: AppConstants.textSize20,
                                  borderRadius: AppConstants.borderRadius4,
                                ),
                        ),
                        Gaps.vGap24,
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  uploadSignUpFile({
    required void Function()? onTap,
    required String text,
    required File file,
    required String image,
    required String asset,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 120.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.hGap20,
              CustomText(
                  text: text,
                  fontSize: AppConstants.textSize18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentColorLight),
              Gaps.hGap12,
              DottedBorder(
                color: AppColors.white,
                dashPattern: const [5, 3],
                radius: const Radius.circular(10),
                borderType: BorderType.Rect,
                strokeWidth: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((Dimens.dp12))),
                  height: Dimens.dp80.h,
                  width: double.infinity,
                  child: file.path.isNotEmpty
                      ? Image.file(file)
                      : image == ''
                          ? Image.asset(asset)
                          : Image.network(image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaContainer(
      {required String title,
      required IconData icon,
      required TextEditingController controller}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: _buildTextFiledWidget(
              type: TextInputType.name,
              validator: (input) => !Validators.isLinkValid(input!)
                  ? LanguageHelper.getTranslation(context).link_invalid
                  : null,
              title: title,
              textEditingController: controller),
        ),
        Gaps.hGap8,
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 30,
              width: 20,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  icon,
                  color: AppColors.accentColorLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageWidget(File file) {
    return BlocBuilder<ShopProfileCubit, ShopProfileState>(
      buildWhen: (previous, current) => current is GetImageState,
      builder: (context, state) {
        return Container(
          height: 0.52.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
            image: file.path.isEmpty
                ? DecorationImage(
                    image: NetworkImage(
                        ShopProfileCubit.of(context).imageNetwork ?? ''),
                    fit: BoxFit.cover)
                : DecorationImage(
                    image: FileImage(File(file.path)), fit: BoxFit.cover),
          ),
          child: Container(
            color: AppColors.primaryColorLight.withOpacity(0.7),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await ShopProfileCubit.of(context).getImage();
                  ShopProfileCubit.of(context).emit(GetImageState());
                },
                child: ImageIcon(
                  const AssetImage(AppConstants.CAMERA_ICON),
                  color: AppColors.white,
                  size: 104.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFiledWidget(
      {required String title,
      bool isPhoneNumber = false,
      required TextInputType type,
      required TextEditingController textEditingController,
      required Function(String? input) validator}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: AppConstants.textSize16,
        ),
        Gaps.vGap4,
        isPhoneNumber
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.white,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius6)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PhoneNumberTextField(
                    border: InputBorder.none,
                    hint: "",
                    textEditingController: textEditingController,
                    onInputChanged: (p0) {},
                  ),
                ),
              )
            : TextFormField(
                controller: textEditingController,
                validator: (value) => validator(value),
                keyboardType: type,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.white,
                  )),
                ),
              ),
      ],
    );
  }

  static String getDay(int dayNum) {
    String? day;
    days.forEach((key, value) {
      if (dayNum == key) {
        day = value;
      }
    });
    return day ?? '';
  }

  static Map<int, String> days = {
    0: 'الأحد',
    1: 'الاتنين',
    2: 'الثلاثاء',
    3: 'الأربعاء',
    4: 'الخميس',
    5: 'الجمعه',
    6: 'السبت',
  };

  List<Weekdays> weekdaysList = [
    Weekdays(
        id: 0,
        day: getDay(0),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 1,
        day: getDay(1),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 2,
        day: getDay(2),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 3,
        day: getDay(3),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 4,
        day: getDay(4),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 5,
        day: getDay(5),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: ''),
    Weekdays(
        id: 6,
        day: getDay(6),
        selectedDays: false,
        selectedFrom: '',
        selectedTo: '')
  ];

  String formattedTime(String dateTime) {
    return DateFormat('hh:mm a').format(DateTime.parse(dateTime));
  }

  Widget _addWorkingHours() {
    return BlocBuilder<ShopProfileCubit, ShopProfileState>(
      builder: (context, state) {
        List<OpeningDays> openingDays =
            ShopProfileCubit.of(context).shopModel!.openingDays ?? [];
        weekdaysList.forEach((element) {
          openingDays.forEach((elementOpeningDays) {
            if (element.id == elementOpeningDays.day) {
              element.selectedFrom = DateFormat.jm()
                  .format(DateTime.parse(elementOpeningDays.from ?? ''));
              element.selectedTo = DateFormat.jm()
                  .format(DateTime.parse(elementOpeningDays.to ?? ''));
              element.selectedDays = true;
            }
          });
        });
        return SizedBox(
          height: 350.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 20.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: weekdaysList[index].selectedDays,
                              activeColor: AppColors.accentColorLight,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  weekdaysList[index].selectedDays = newValue!;
                                });
                              },
                            ),
                            CustomText(
                              text: weekdaysList[index].day ?? '',
                              fontSize: AppConstants.textSize12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 20.h,
                        child: const CustomText(text: "من"),
                      ),
                    ),
                    Gaps.hGap4,
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: AppColors.white),
                          ),
                          height: 30.h,
                          child: HourDropDown(
                            selectedHour: '٢:٠٠ ص',
                          ),
                        )),
                    Gaps.hGap4,
                    Expanded(
                      child: SizedBox(
                        height: 20.h,
                        child: const CustomText(text: "الي"),
                      ),
                    ),
                    Gaps.hGap4,
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: AppColors.white)),
                          height: 30.h,
                          child: HourDropDown(
                            selectedHour: '٢:٠٠ ص',
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HourDropDown extends StatefulWidget {
  String? selectedHour;

  HourDropDown({super.key, required this.selectedHour});

  @override
  _HourDropDownState createState() => _HourDropDownState();
}

class _HourDropDownState extends State<HourDropDown> {
  // String selectedHour = '01:00 AM'; // Default selected hour
  List<String> hoursList = [
    '١:٠٠ ص',
    '٢:٠٠ ص',
    '٣:٠٠ ص',
    '٤:٠٠ ص',
    '٥:٠٠ ص',
    '٦:٠٠ ص',
    '٧:٠٠ ص',
    '٨:٠٠ ص',
    '٩:٠٠ ص',
    '١٠:٠٠ ص',
    '١١:٠٠ ص',
    '١٢:٠٠ ص',
    '١:٠٠ م',
    '٢:٠٠ م',
    '٣:٠٠ م',
    '٤:٠٠ م',
    '٥:٠٠ م',
    '٦:٠٠ م',
    '٧:٠٠ م',
    '٨:٠٠ م',
    '٩:٠٠ م',
    '١٠:٠٠ م',
    '١١:٠٠ م',
    '١٢:٠٠ م'
  ]; // List of hours

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: DropdownButton<String>(
        value: widget.selectedHour,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.accentColorLight,
        ),
        onChanged: (String? newValue) {
          setState(() {
            widget.selectedHour = newValue!;
          });
        },
        items: hoursList.map<DropdownMenuItem<String>>((String hour) {
          return DropdownMenuItem<String>(
            value: hour,
            child: CustomText(
                text: hour,
                color: AppColors.accentColorLight,
                fontSize: AppConstants.textSize12),
          );
        }).toList(),
        underline: Container(),
        isExpanded: true,
      ),
    );
  }
}

class Weekdays {
  String? day;
  int? id;
  bool? selectedDays;
  String? selectedFrom;
  String? selectedTo;

  Weekdays(
      {required this.day,
      required this.id,
      required this.selectedDays,
      required this.selectedFrom,
      required this.selectedTo});
}

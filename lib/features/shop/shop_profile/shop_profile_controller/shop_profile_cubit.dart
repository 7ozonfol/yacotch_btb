import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:trainee_restaurantapp/core/localization/language_helper.dart';
import 'package:trainee_restaurantapp/features/shop/shop_profile/data/models/update_shop_profile_model.dart';
import '../../../../core/location/LocationAddressImports.dart';
import '../../../../core/location/location_cubit/location_cubit.dart';
import '../../../../core/location/model/location_model.dart';
import '../../../../core/ui/toast.dart';
import '../../../../core/utils/Utils.dart';
import '../../../core_features/navigator_home/view/navigator_home_view.dart';
import '../../../../core/models/shop_model.dart';
import '../data/repositories/ShopProfileRepo.dart';

part 'shop_profile_state.dart';

class ShopProfileCubit extends Cubit<ShopProfileState> {
  ShopProfileCubit() : super(ShopProfileInitial());

  static ShopProfileCubit of(context) => BlocProvider.of(context);

  final shopProfileRepo = ShopProfileRepo();

  ShopModel? shopModel;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? imageNetwork;
  TextEditingController nameArController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  String? logoArNetwork;
  String? logoEnNetwork;
  String? coveArNetwork;
  String? coveEnNetwork;
  TextEditingController phoneController = TextEditingController();
  TextEditingController commercialRegisterNumberController =
      TextEditingController();
  String? commercialRegisterDoc;
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController buildNumController = TextEditingController();
  TextEditingController mangerController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instegramController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  File? fileLogoAr;
  File? fileLogoEn;
  File? fileCoveEn;
  File? fileCoveAr;
  File? fileCommercialRegisterDoc;

  String? imgLogoAr;
  String? imgLogoEn;
  String? imgCoveEn;
  String? imgCoveAr;
  String? imgCommercialRegisterDoc;

  TextEditingController descArController = TextEditingController();
  TextEditingController descEnController = TextEditingController();

  final LocationCubit locationCubit = LocationCubit();

  Future uploadImage(BuildContext context, File file) async {
    emit(UploadImageLoading());
    final res = await shopProfileRepo.uploadImage(file);
    res.fold(
      (err) {
        Toast.show(err);
        emit(ShopProfileInitial());
      },
      (res) async {
        if (file == fileLogoAr) {
          imgLogoAr = res;
        } else if (file == fileLogoEn) {
          imgLogoEn = res;
        } else if (file == fileCoveEn) {
          imgCoveEn = res;
        } else if (file == fileCoveAr) {
          imgCoveAr = res;
        } else if (file == fileCommercialRegisterDoc) {
          imgCommercialRegisterDoc = res;
        }
        emit(UploadImageLoaded());
      },
    );
  }

  Future updateShopProfile(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      List<Future> futureList = [];
      if (fileLogoAr != null) {
        futureList.add(uploadImage(context, fileLogoAr!));
      }
      if (fileLogoEn != null) {
        futureList.add(uploadImage(context, fileLogoEn!));
      }
      if (fileCoveAr != null) {
        futureList.add(uploadImage(context, fileCoveAr!));
      }
      if (fileCoveEn != null) {
        futureList.add(uploadImage(context, fileCoveEn!));
      }
      if (fileCommercialRegisterDoc != null) {
        futureList.add(uploadImage(context, fileCommercialRegisterDoc!));
      }
      if (formKey.currentState!.validate()) {
        emit(UploadImageLoading());
        await Future.wait(futureList);
        UpdateShopProfileModel updateShopProfileModel = UpdateShopProfileModel(
          id: shopModel!.id,
          arName: nameArController.text,
          enName: nameEnController.text,
          arDescription: descArController.text,
          enDescription: descEnController.text,
          arLogo: imgLogoAr ?? shopModel!.arLogo,
          enLogo: imgLogoEn ?? shopModel!.enLogo,
          arCover: imgCoveAr ?? shopModel!.arCover,
          enCover: imgCoveEn ?? shopModel!.enCover,
          commercialRegisterNumber: commercialRegisterNumberController.text,
          commercialRegisterDocument:
              imgCommercialRegisterDoc ?? shopModel!.commercialRegisterDocument,
          cityId: shopModel!.cityId,
          street: shopModel!.street,
          phoneNumber: phoneController.text,
          facebookUrl: facebookController.text,
          instagramUrl: instegramController.text,
          twitterUrl: twitterController.text,
          websiteUrl: websiteController.text,
          latitude: locationCubit.state.model!.lat,
          longitude: locationCubit.state.model!.lng,
        );

        final res =
            await shopProfileRepo.updateShopProfile(updateShopProfileModel);
        print("afterrrrrr");
        res.fold(
          (err) {
            Toast.show(err);
            emit(UpdateShopProfileError());
          },
          (res) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigatorScreen(homeType: 4)),
                (route) => false);
            emit(UpdateShopProfileLoaded());
          },
        );
      } else {
        Toast.show(LanguageHelper.getTranslation(context).complete_data);
      }
    }
  }

  Future getShopProfile(BuildContext context) async {
    emit(GetShopProfileLoading());
    final res = await shopProfileRepo.getShopProfile();
    res.fold(
      (err) {
        Toast.show(err);
        emit(GetShopProfileError());
      },
      (res) {
        shopModel = res;
        res.openingDays!.forEach((element) {
          print(element.day);
          print(DateFormat('HH:mm').format(DateTime.parse(element.from ?? '')));
          print(DateFormat('HH:mm').format(DateTime.parse(element.to ?? '')));
          print("----------------------------");
        });
        emit(GetShopProfileLoaded());
      },
    );
  }

  Map<int, String> dayMap = {
    0: "السبت",
    1: "الأحد",
    2: "الاتنين",
    3: "الثلاثاء",
    4: "الاربعاء",
    5: "الخميس",
    6: "الجمعه",
  };

  String convertDays(int dayNum) {
    String? day;
    dayMap.forEach((key, value) {
      if (key == dayNum) {
        day = value;
      }
    });
    return day ?? '';
  }

  final List<String> restaurantProfileConstantList = [
    "رقم الهاتف",
    "رقم السجل التجاري",
    "السجيل التجاري",
    "مدير المطعم",
    // "البلد",
    // "المدينه",
    // "الشارع",
    // "رقم البناء"
  ];

  Future<XFile?> getImage() async {
    ImagePicker picker = ImagePicker();
    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      return result;
    }
    return null;
  }

  Future<void> pickCommericalDoc() async {
    var result = await getImage();
    print(result!.path);
    fileCommercialRegisterDoc = File(result!.path);
    emit(ImageCommericalPicked());
  }

  Future<void> pickLogoAr() async {
    var result = await getImage();
    fileLogoAr = File(result!.path);
    emit(ImageLogoArPicked());
  }

  Future<void> pickLogoEn() async {
    var result = await getImage();
    fileLogoEn = File(result!.path);
    emit(ImageLogoEnPicked());
  }

  Future<void> pickCoverEn() async {
    var result = await getImage();
    fileCoveEn = File(result!.path);
    emit(ImageCoverEnPicked());
  }

  Future<void> pickCoverAr() async {
    var result = await getImage();
    fileCoveAr = File(result!.path);
    emit(ImageCoverArPicked());
  }

  onLocationClick(context) async {
    var _loc = await Utils.getCurrentLocation(context);
    locationCubit.onLocationUpdated(LocationModel(
      lat: _loc?.latitude ?? 32.4,
      lng: _loc?.longitude ?? 32.4,
      address: "",
    ));
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) {
          return FadeTransition(
              opacity: animation,
              child: BlocProvider.value(
                value: locationCubit,
                child: LocationAddress(),
              ));
        },
      ),
    );
  }
}

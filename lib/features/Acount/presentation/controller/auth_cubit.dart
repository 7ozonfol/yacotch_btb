// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trainee_restaurantapp/core/appStorage/app_storage.dart';
import 'package:trainee_restaurantapp/core/dioHelper/dio_helper.dart';
import 'package:trainee_restaurantapp/core/navigation/helper.dart';
import 'package:trainee_restaurantapp/core/net/api_url.dart';
import 'package:trainee_restaurantapp/features/Acount/data/models/register_restaurant_model.dart';
import 'package:trainee_restaurantapp/features/Acount/presentation/screens/login_screen.dart';
import '../../../../core/common/app_colors.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/errors/app_errors.dart';
import '../../../../core/location/LocationAddressImports.dart';
import '../../../../core/location/location_cubit/location_cubit.dart';
import '../../../../core/location/model/location_model.dart';
import '../../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../../core/ui/error_ui/error_viewer/snack_bar/errv_snack_bar_options.dart';
import '../../../../core/ui/toast.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../generated/l10n.dart';
import '../../../core_features/navigator_home/view/navigator_home_view.dart';
import '../../../core_features/main_onboarding_view.dart';
import '../../data/models/specialization_model.dart';
import '../../data/repositories/auth_repo.dart';
import '../screens/account_verification.dart';
import '../screens/forget_password_verification.dart';
import 'package:file_picker/file_picker.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit of(context) => BlocProvider.of(context);

  final authRepo = AuthRepo();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController descArController = TextEditingController();
  TextEditingController descEnController = TextEditingController();
  TextEditingController commercialNumberController = TextEditingController();
  TextEditingController restaurantManagerNameController =
      TextEditingController();
  TextEditingController phoneRestaurantController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController buildNumController = TextEditingController();
  TextEditingController mangerController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instegramController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController nameArController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  TextEditingController commercialRegisterNumberController =
      TextEditingController();

  late String countryCode = AppConstants.DEFAULT_COUNTRY_CODE;

  bool isLoading = false;
  bool boxChecked = true;

  bool passwordSecure = true;
  bool confirmPasswordSecure = true;

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

  String? logoArNetwork;
  String? logoEnNetwork;
  String? coveArNetwork;
  String? coveEnNetwork;

  List<Items> listSpecialization = [];
  Items? dropdownValueCate;

  final LocationCubit locationCubit = LocationCubit();

  late String otpValue;
  File? file;

  String? img;

  late String verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

//1000 1001 1002
  Future assignSubscriptionToUser(BuildContext context, int type) async {
    emit(AssignSubscriptionToUserLoading());
    final res = await authRepo.assignSubscriptionToUser(type);
    res.fold(
      (err) {
        Toast.show(err);
        emit(AssignSubscriptionToUserError());
      },
      (res) async {
        //Toast.show('تم بنجاح');
        emit(AssignSubscriptionToUserLoaded());
      },
    );
  }

  Future<void> submitPhoneNumber({newPhone}) async {
    debugPrint("*" * 50);
    debugPrint("*" * 50);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: newPhone ?? "+2001011153207",
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeRetrivalTimeOut,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    debugPrint("${credential.smsCode}");
    debugPrint("creadintial complated");
    await auth.signInWithCredential(credential);
  }

  void verificationFailed(FirebaseAuthException e) {
    debugPrint("Error in verification");
  }

  bool countState = false;

  codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    countState = true;
  }

  void codeRetrivalTimeOut(String verificationId) {
    debugPrint("code Auto rerival Time");
  }

  Future<bool> submitOTP(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    await smsSignIn(credential).whenComplete(() {
      return true;
    });
    return false;
  }

  Future<void> smsSignIn(PhoneAuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential);
    } catch (error) {
      print(error);
    }
  }

  Future uploadImage(BuildContext context, File file) async {
    emit(UploadImageLoading());
    final res = await authRepo.uploadImage(file);
    res.fold(
      (err) {
        Toast.show(err);
        emit(AuthInitial());
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
        //  emit(UploadImageLoaded());
      },
    );
  }

  Future getSpecialization() async {
    emit(GetSpecializationLoading());
    final res = await authRepo.getSpecialization();
    res.fold(
      (err) {
        Toast.show(err);
      },
      (res) {
        listSpecialization = res.result!.items ?? [];
        emit(GetSpecializationLoaded());
      },
    );
  }

  Future logout(BuildContext context) async {
    emit(LogoutLoading());
    final res = await authRepo.logout(context);
    res.fold(
      (err) {
        Toast.show(err);
        emit(AuthInitial());
      },
      (res) async {
        AppStorage.signOut();
        NavigationHelper.gotoAndRemove(
            screen: const MainOnBoardingView(), context: context);
        emit(LogoutLoaded());
      },
    );
  }

  Future changePassword(BuildContext context, int typeUser) async {
    if (formKey.currentState!.validate()) {
      emit(ChangePasswordLoading());
      isLoading = true;
      final res = await authRepo.changePassword(
          passwordController.text, confirmPasswordController.text);
      res.fold(
        (err) {
          isLoading = false;
          Toast.show(err);
          emit(AuthInitial());
        },
        (res) async {
          isLoading = false;
          NavigationHelper.pop(context);
          emit(ChangePasswordLoaded());
        },
      );
    }
  }

  Future resendCode(BuildContext context, String phone, int userType) async {
    unFocus(context);
    emit(ResendCodeLoading());
    final res = await authRepo.resendCode(phone, userType);
    res.fold(
      (err) {
        Toast.show(err);
        emit(ResendCodeError());
      },
      (res) async {
        Toast.show('تم ارسال الكود بنجاح');
        emit(ResendCodeLoaded());
      },
    );
  }

  Future verifyAccount(BuildContext context, String phone, int userType) async {
    // if (formKey.currentState!.validate() && codeController.text.length == 6) {
      unFocus(context);
      emit(VerifyAccountLoading());
      isLoading = true;
      final res = await authRepo.verifyAccount(
        phone,
        '000000',
      );
      res.fold(
        (err) {
          isLoading = false;
          Toast.show(err);
          emit(VerifyAccountError());
        },
        (res) async {
          isLoading = false;
          // await assignSubscriptionToUser(context, 1000, userType);

          if (userType == 1) {
            NavigationHelper.gotoAndRemove(
              screen: const LoginScreen(1),
              context: context,
            );
            emit(VerifyAccountLoaded());
          } else if (userType == 3) {
            NavigationHelper.goto(
                screen: LoginScreen(userType), context: context);
            emit(VerifyAccountLoaded());
          } else if (userType == 4) {
            NavigationHelper.goto(
                screen: LoginScreen(userType), context: context);
            emit(VerifyAccountLoaded());
          }
        },
      );
    // }
  }

  Future registerShop(BuildContext context, int userType) async {
    await uploadImage(context, fileCommercialRegisterDoc!);
    RegisterRestaurantModel model = RegisterRestaurantModel(
      name: restaurantNameController.text,
      email: emailController.text,
      password: passwordController.text,
      phoneNumber: phoneController.text,
      commercialRegisterDocument: imgCommercialRegisterDoc,
      commercialRegisterNumber: commercialNumberController.text,
      cityId: 1,
      managerCountryCode: countryCode,
      managerName: restaurantManagerNameController.text,
      managerPhoneNumber: phoneRestaurantController.text,
    );
    print(model.toJson());
    if (formKey.currentState!.validate()) {
      if (boxChecked) {
        unFocus(context);
        emit(RegisterShopLoading());
        isLoading = true;
        final res = await authRepo.registerShop(model);
        res.fold(
          (err) {
            isLoading = false;
            Toast.show(err);
            log(err.toString());
            emit(RegisterShopError());
          },
          (res) async {
            submitPhoneNumber(
                newPhone: "$countryCode${phoneRestaurantController.text}");
            log("res");
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => AccountVerificationScreenContent(
            //           phone: phoneRestaurantController.text,
            //           userType: userType,
            //         )));
            // NavigationHelper.gotoAndRemove(screen: LoginScreen(userType), context: context);
            isLoading = false;
            emit(RegisterShopLoaded());
          },
        );
      } else {
        ErrorViewer.showError(
            errorViewerOptions:
                const ErrVSnackBarOptions(backgroundColor: AppColors.grey),
            context: context,
            error: CustomError(
                message: Translation.of(context).accept_terms_conditions),
            callback: () {});
      }
    }
    Future.delayed(Duration(milliseconds: 500), ()=> verifyAccount(context,phoneController.text, userType));
  }

  RegisterRestaurantModel? signUpRestaurantModel;
  Future registerRestaurant(BuildContext context, int userType) async {
    emit(RegisterRestaurantLoading());
    await uploadImage(context, fileCommercialRegisterDoc!);

    signUpRestaurantModel = RegisterRestaurantModel(
      name: restaurantNameController.text,
      email: emailController.text,
      password: passwordController.text,
      phoneNumber: phoneController.text,
      commercialRegisterDocument: imgCommercialRegisterDoc,
      commercialRegisterNumber: commercialNumberController.text,
      cityId: 1,
      managerCountryCode: countryCode,
      managerName: restaurantManagerNameController.text,
      managerPhoneNumber: phoneRestaurantController.text,
    );
    if (formKey.currentState!.validate()) {
      if (boxChecked) {
        unFocus(context);
        isLoading = true;
        final res = await authRepo.registerRestaurant(signUpRestaurantModel!);
        print(await signUpRestaurantModel!.toJson());
        res.fold(
          (err) {
            isLoading = false;
            Toast.show(err);
            emit(RegisterRestaurantError());
          },
          (res) async {
            submitPhoneNumber(
                newPhone: "$countryCode${phoneRestaurantController.text}");
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => AccountVerificationScreenContent(
            //           phone: phoneRestaurantController.text,
            //           userType: userType,
            //         )));

            // NavigationHelper.gotoAndRemove(screen: LoginScreen(userType), context: context);

            isLoading = false;
            emit(RegisterRestaurantLoaded());
          },
        );
      } else {
        ErrorViewer.showError(
            errorViewerOptions:
                const ErrVSnackBarOptions(backgroundColor: AppColors.grey),
            context: context,
            error: CustomError(
                message: Translation.of(context).accept_terms_conditions),
            callback: () {});
      }
    }
    Future.delayed(Duration(milliseconds: 500), ()=> verifyAccount(context,phoneController.text, userType));
  }

  Future registerTrainer(BuildContext context, int userType) async {
    if (formKey.currentState!.validate()) {
      if (boxChecked) {
        unFocus(context);
        emit(RegisterTrainerLoading());
        isLoading = true;
        final res = await authRepo.registerTrainer(
          phoneNumber: phoneController.text,
          name: nameController.text,
          countryCode: countryCode,
          password: passwordController.text,
          specializationId: dropdownValueCate!.id!,
        );

        res.fold(
          (err) {
            isLoading = false;
            Toast.show(err);
            emit(RegisterTrainerError());
          },
          (res) async {
            submitPhoneNumber(newPhone: "$countryCode${phoneController.text}");
            // NavigationHelper.goto(
            //     screen: AccountVerificationScreenContent(
            //       phone: phoneController.text,
            //       userType: userType,
            //     ),
            //     context: context);
            // NavigationHelper.gotoAndRemove(screen: LoginScreen(userType), context: context);
            isLoading = false;
            emit(RegisterTrainerLoaded());
          },
        );
      } else {
        ErrorViewer.showError(
            errorViewerOptions:
                const ErrVSnackBarOptions(backgroundColor: AppColors.grey),
            context: context,
            error: CustomError(
                message: Translation.of(context).accept_terms_conditions),
            callback: () {});
      }
    }
    Future.delayed(Duration(milliseconds: 500), ()=> verifyAccount(context,phoneController.text, userType));
  }

  Future confirmForgotPassword(
      BuildContext context, String phone, String code, int userType) async {
    if (formKey.currentState!.validate()) {
      unFocus(context);
      emit(ForgetPasswordVerifyLoading());
      isLoading = true;
      final res = await authRepo.forgetPasswordVerify(
          phone, code, passwordController.text);
      res.fold(
        (err) {
          isLoading = false;
          Toast.show(err);
          emit(ForgetPasswordVerifyError());
        },
        (res) async {
          NavigationHelper.gotoAndRemove(
              screen: LoginScreen(userType), context: context);
          isLoading = false;
          emit(ForgetPasswordVerifyLoaded());
        },
      );
    }
  }

  Future forgetPassword(BuildContext context, int userType) async {
    if (formKey.currentState!.validate()) {
      unFocus(context);
      emit(ForgetPasswordLoading());
      isLoading = true;
      final res = await authRepo.forgetPassword(phoneController.text);
      res.fold(
        (err) {
          isLoading = false;
          Toast.show(err);
          emit(ForgetPasswordError());
        },
        (res) async {
          // NavigationHelper.goto(
          //     screen: ForgetPasswordVerificationScreenContent(
          //         email: "",
          //         passsword: "",
          //         phone: phoneController.text,
          //         userType: userType),
          //     context: context);
          NavigationHelper.gotoAndRemove(
              screen: LoginScreen(userType), context: context);
          Toast.show(Translation.of(context).check_email);

          isLoading = false;
          emit(ForgetPasswordLoaded());
        },
      );
    }
  }

  Future login(BuildContext context, int userType, [String? phone]) async {
    if (formKey.currentState!.validate()) {
      unFocus(context);
      emit(LoginLoading());
      isLoading = true;
      final res = await authRepo.login(
        phone ?? phoneController.text,
        passwordController.text,
        userType,
      );

      res.fold(
        (err) async {
          isLoading = false;
          Toast.show(err['details']);
          emit(LoginError());
          if (err['code'] == 4) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AccountVerificationScreenContent(
                  phone: phone ?? phoneController.text,
                  userType: userType,
                ),
              ),
            );
          }
        },
        (res) async {
          await AppStorage.cacheUserInfo(res);
          await assignSubscriptionToUser(context, userType);
          NavigationHelper.gotoAndRemove(
              screen: NavigatorScreen(
                homeType: res.result!.shopId != null
                    ? 4
                    : res.result!.restaurantId != null
                        ? 3
                        : 1,
              ),
              context: context);

          isLoading = false;
          await updateDeviceToken();
          emit(LoginLoaded());
        },
      );
    }
  }

  unFocus(context) {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
  }

  Future<File?> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    }
    return null;
  }

  Future<XFile?> getImage() async {
    ImagePicker picker = ImagePicker();
    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      emit(PickedImageState(File(result.path)));
      return result;
    }
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

  Future<void> pickFile() async {
    var result = await getImage();
    file = File(result!.path);
  }

  Future<void> pickCommericalDoc() async {
    var result = await getImage();
    print(result!.path);
    fileCommercialRegisterDoc = File(result!.path);
  }

  Future<void> pickLogoAr() async {
    var result = await getImage();
    fileLogoAr = File(result!.path);
  }

  Future<void> pickLogoEn() async {
    var result = await getImage();
    fileLogoEn = File(result!.path);
  }

  Future<void> pickCoverEn() async {
    var result = await getImage();
    fileCoveEn = File(result!.path);
  }

  Future<void> pickCoverAr() async {
    var result = await getImage();
    fileCoveAr = File(result!.path);
  }

  Future<void> updateDeviceToken() async {
    log("message");
    var token = await FirebaseMessaging.instance.getToken();
    print("fcm token : $token");
    final result = await DioHelper.put(APIUrls.API_UPDATE_DEVICE_TOKEN,
        body: {"token": token ?? ""});

    print(result.data);
  }

  void deleteAccount(int id) async {
    emit(MoreLoading());
    await authRepo.deleteAccount(id).then((value) => value.fold(
        (l) => emit(MoreAccountDeletionFailed()),
        (r) => emit(MoreAccountDeletedSucc())));
  }
}

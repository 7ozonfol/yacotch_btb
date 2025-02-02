import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:trainee_restaurantapp/core/localization/language_helper.dart';
import '../../common/app_colors.dart';
import '../../common/validators.dart';
import '../../constants/app/app_constants.dart';
import '../../../core/library/intl_phone_filed/phone_number_field.dart'
    as custom_phone_number;

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? passwordSecure;

  final Function(bool)? hidePassword;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final TextInputType? textInputType;
  final InputBorder? inputBorder;
  final String? labelText;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prefix;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.passwordSecure = false,
    this.hidePassword,
    this.isPassword = false,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textInputType,
    this.inputBorder,
    this.labelText,
    this.maxLines,
    this.suffix,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: textInputType,
      onFieldSubmitted: (text) {
        if (onFieldSubmitted != null) onFieldSubmitted!();
      },
      validator: validator,
      textInputAction: textInputAction ?? TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffix,
        prefixIcon: prefix,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        errorBorder: inputBorder,
        disabledBorder: inputBorder,
      ),
      maxLines: passwordSecure! ? 1 : maxLines,
      obscureText: passwordSecure!,
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  final InputBorder? border;
  final String? hint;
  final TextEditingController textEditingController;
  final Function(String) onInputChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final String isoCode;

  const PhoneNumberTextField(
      {Key? key,
      this.border,
      this.hint,
      required this.textEditingController,
      required this.onInputChanged,
      this.focusNode,
      this.textInputAction,
      this.onFieldSubmitted,
      this.isoCode = AppConstants.DEFAULT_COUNTRY_CODE})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(isoCode);
    return custom_phone_number.PhoneNumberField(
      textFieldController: textEditingController,
      focusNode: focusNode,
      formatInput: false,
      onFieldSubmitted: (term) {
        if (onFieldSubmitted != null) onFieldSubmitted!();
      },
      keyboardAction: textInputAction ?? TextInputAction.next,
      initialValue: PhoneNumber(isoCode: isoCode),
      onInputChanged: (selectedCountry) {
        onInputChanged(selectedCountry.isoCode ?? isoCode);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      selectorTextStyle: const TextStyle(color: AppColors.white_text),
      validator: (text) {
        if (!Validators.isNotEmptyString(text ?? '')) {
          return LanguageHelper.getTranslation(context).enter_phone_number;
        }
        if (!Validators.isValidPhoneNumber(text ?? '')) {
          return LanguageHelper.getTranslation(context).enter_valid_phone;
        }
        return null;
      },
      inputDecoration: InputDecoration(
        labelText: hint ?? LanguageHelper.getTranslation(context).phone,
        border: border,
        disabledBorder: border,
        enabledBorder: border,
        errorBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
      ),
    );
  }
}

class NormalTextField extends StatelessWidget {
  final InputBorder? inputBorder;
  final bool hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final int? maxLines;

  const NormalTextField({
    Key? key,
    this.inputBorder,
    this.hint = true,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      validator: (value) {
        if (value == null || value == '') {
          return LanguageHelper.getTranslation(context).insert_value;
        }
        return null;
      },
      textInputType: TextInputType.text,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      focusNode: focusNode,
      inputBorder: inputBorder,
      maxLines: maxLines,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final bool passwordSecure;
  final bool? isConfirmPassword;
  final Function(bool) hidePassword;
  final TextEditingController controller;
  final TextEditingController? otherPasswordController;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function? onFiledSubmitted;
  final String? text;

  const PasswordTextField(
      {Key? key,
      required this.passwordSecure,
      required this.hidePassword,
      this.isConfirmPassword = false,
      required this.controller,
      this.otherPasswordController,
      this.textInputAction,
      this.focusNode,
      this.onFiledSubmitted,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? hidePasswordWidget;
    !passwordSecure
        ? hidePasswordWidget = GestureDetector(
            onTap: () {
              hidePassword(true);
            },
            child: const Icon(
              Icons.visibility_off_outlined,
              color: AppColors.white,
            ))
        : hidePasswordWidget = GestureDetector(
            onTap: () {
              hidePassword(false);
            },
            child: const Icon(
              Icons.visibility_outlined,
              color: AppColors.white,
            ));
    return CustomTextField(
      validator: isConfirmPassword!
          ? (text) {
              if (!Validators.isNotEmptyString(text ?? '')) {
                return LanguageHelper.getTranslation(context).enter_confirm_password;
              }
              if (!Validators.isValidConfirmPassword(
                  text ?? '',
                  otherPasswordController == null
                      ? ''
                      : otherPasswordController!.text)) {
                return LanguageHelper.getTranslation(context).passwords_not_match;
              }
              return null;
            }
          : (text) {
              if (!Validators.isNotEmptyString(text ?? '')) {
                return LanguageHelper.getTranslation(context).enter_password;
              }
              if (!Validators.isValidPassword(
                text ?? '',
              )) return LanguageHelper.getTranslation(context).enter_valid_password;
              return null;
            },
      textInputType: TextInputType.visiblePassword,
      controller: controller,
      labelText: text != null
          ? text
          : !isConfirmPassword!
              ? LanguageHelper.getTranslation(context).password
              : LanguageHelper.getTranslation(context).confirmPassword,
      hidePassword: hidePassword,
      isPassword: true,
      onFieldSubmitted: onFiledSubmitted,
      passwordSecure: passwordSecure,
      textInputAction: textInputAction,
      focusNode: focusNode,
      suffix: hidePasswordWidget,
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function? onFiledSubmitted;
  final String? text;
  final String? Function(String? input)? validator;
  final TextInputType keboardType;
  const EmailTextField(
      {Key? key,
      this.validator,
      this.keboardType = TextInputType.name,
      required this.controller,
      this.textInputAction,
      this.focusNode,
      this.onFiledSubmitted,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      onFieldSubmitted: (_) {
        FocusScope.of(context).nextFocus();
      },
      validator: (text) {
        if (validator == null) {
          if (!Validators.isNotEmptyString(text ?? '')) {
            return LanguageHelper.getTranslation(context).errorEmptyField;
          }
        } else {
          return validator!(text);
        }
        return null;
      },
      labelText: text,
      textInputType: keboardType,
      controller: controller,
      isPassword: true,
      textInputAction: textInputAction,
    );
  }
}

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const SearchTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.onFieldSubmitted,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: hintText,
      inputBorder: InputBorder.none,
      prefix: const Icon(
        Icons.search,
        color: AppColors.white,
      ),
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
    );
  }
}

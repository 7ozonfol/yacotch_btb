import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainee_restaurantapp/core/common/app_colors.dart';
import 'package:trainee_restaurantapp/core/localization/language_helper.dart';
import 'package:trainee_restaurantapp/features/trainer/chat/data/model/chat_model.dart';
import 'package:trainee_restaurantapp/features/trainer/chat/view/widgets/recent_chats_list_view.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  ChatModel? searchResult;

// Initialize Firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> searchChatByTraineeName(String traineeName) async {
    try {
      String startingLetter = traineeName.toLowerCase();
      String nextLetter = String.fromCharCode(startingLetter.runes.first + 1);

      QuerySnapshot querySnapshot = await firestore
          .collection('chats')
          .where('traineeName',
              isGreaterThanOrEqualTo: startingLetter, isLessThan: nextLetter)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // You have documents that match the traineeName.
        // You can access them from querySnapshot.docs.
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          searchResult =
              ChatModel.fromJson(document.data() as Map<String, dynamic>);
        }
      } else {}
    } catch (error) {
      searchResult = null;
    }
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.backgroundGradient3,
                  AppColors.backgroundGradient2,
                  AppColors.backgroundGradient1,
                ]),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: TextFormField(
            onChanged: (name) async {
              await searchChatByTraineeName(name);
              setState(() {});
            },
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              //todo translate
              hintText: 'Search for any chat',
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,

              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
            height: .5.sh,
            child: searchResult == null && controller.text.isEmpty
                ? const RecentChatsListView()
                : searchResult == null && controller.text.isNotEmpty
                    ? Center(
                        child: Text(LanguageHelper.getTranslation(context)
                            .no_data_found))
                    : searchResult != null
                        ? Column(
                            children: [
                              ChatSummaryWidget(searchResult!),
                            ],
                          )
                        : const SizedBox())
      ],
    );
  }
}

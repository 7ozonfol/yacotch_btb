import 'package:flutter/material.dart';
import 'package:trainee_restaurantapp/features/core_features/more/presentation/app_setting/feed_back/content.dart';
import '../../../../../../core/ui/widgets/custom_appbar.dart';
import '../../../../../../generated/l10n.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(
        title: Translation.of(context).feedback,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const FeedbackScreenContent(),
    );
  }
}

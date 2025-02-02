import 'package:flutter/material.dart';
import '../../common/style/text_styles.dart';

class MoreItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onPressed;

  const MoreItem({
    Key? key,
    required this.image,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.transparent, disabledForegroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.38),
          ),
          onPressed: onPressed ?? () {},
          child: ListTile(
            leading: Image.asset(
              image,
              color: Theme.of(context).primaryColor,
              height: 30,
            ),
            title: Text(
              title,
              textScaleFactor: 1.0,
              style: AppTextStyles().headline5,
            ),
          ),
        ),
        const Divider(
          indent: 1,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../resources/all_resources.dart';

Widget errorContainer() {
  return Container(
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      'assets/images/img_not_available.jpeg',
      height: Sizes.dimen_200,
      width: Sizes.dimen_200,
    ),
  );
}

Widget chatImage({required String imageSrc, required Function onTap}) {
  return OutlinedButton(
    onPressed: onTap(),
    child: Image.network(
      imageSrc,
      width: Sizes.dimen_200,
      height: Sizes.dimen_200,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            color: ColorManager.greyColor2,
            borderRadius: BorderRadius.circular(Sizes.dimen_10),
          ),
          width: Sizes.dimen_200,
          height: Sizes.dimen_200,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorManager.burgundy,
              value: loadingProgress.expectedTotalBytes != null &&
                      loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, object, stackTrace) => errorContainer(),
    ),
  );
}

Widget messageBubble(
    {required String chatContent,
    bool isMe = true,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor}) {
  return Container(
    padding: const EdgeInsets.all(Sizes.dimen_18),
    margin: margin,
    width: Sizes.dimen_230,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.dimen_18),
          topLeft: Radius.circular(Sizes.dimen_18),
          bottomLeft: Radius.circular(isMe ? Sizes.dimen_18 : Sizes.dimen_0),
          bottomRight: Radius.circular(!isMe ? Sizes.dimen_18 : Sizes.dimen_0)),
    ),
    child: Text(
      chatContent,
      style: TextStyle(
          fontSize: Sizes.dimen_16,
          color: textColor,
          overflow: TextOverflow.visible),
    ),
  );
}

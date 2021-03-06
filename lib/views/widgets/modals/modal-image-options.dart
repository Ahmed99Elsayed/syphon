// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:syphon/global/dimensions.dart';

class ModalImageOptions extends StatelessWidget {
  ModalImageOptions({
    Key key,
    this.onSetNewAvatar,
  }) : super(key: key);

  final Function onSetNewAvatar;

  @override
  Widget build(BuildContext context) => Container(
        height: Dimensions.defaultModalHeight,
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 24,
              ),
              child: Text(
                'Photo Select Method',
                textAlign: TextAlign.start,
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              title: Text(
                'Take Photo',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () async {
                final File image = await ImagePicker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: Dimensions.avatarSizeMax,
                  maxHeight: Dimensions.avatarSizeMax,
                );

                if (this.onSetNewAvatar != null) {
                  this.onSetNewAvatar(image: image);
                }

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.photo_library,
                  size: 28,
                ),
              ),
              title: Text(
                'Pick from gallery',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () async {
                final File image = await ImagePicker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: Dimensions.avatarSizeMax,
                  maxHeight: Dimensions.avatarSizeMax,
                );

                if (onSetNewAvatar != null) {
                  onSetNewAvatar(image: image);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              enabled: false,
              leading: Container(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.delete_forever,
                  size: 34,
                ),
              ),
              title: Text(
                'Remove photo',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      );
}

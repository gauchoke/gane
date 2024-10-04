import 'dart:async';
import 'dart:io';
import 'package:gane/src/Widgets/dialog_select_picker_image.dart';
import 'package:flutter/material.dart';

import 'package:gane/src/Utils/colors.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/interface_permission_gallery.dart';

class ImagePickerHandler{

  late DialogSelectPickerImage imagePicker;
  AnimationController controller;
  ImagePickerListener listener;
  final color;
  final prefs = SharePreference();

   ImagePickerHandler(this.listener, this.controller, this.color);

  openCamera() async {
    imagePicker.dismissDialog();
    //var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var image = await ImagePicker().pickImage(source: ImageSource.camera,maxWidth: 256,maxHeight: 256);
    listener.userImage(File(image!.path));
    //cropImage(image);
    //cropImage(File(image!.path));
  }

  openGallery(BuildContext context, InterfacePermissionGalleryClass interface) async {

    try{
      imagePicker.dismissDialog();
      //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      var image = await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 256,maxHeight: 256);
      //_listener.userImage(image);
      //cropImage(image);
      //cropImage(File(image!.path));
      listener.userImage(File(image!.path));
      prefs.permissionGallery = "0";
      interface.funcOpenDialog(context);

    }catch (err){
      print('Error: $err');
      prefs.permissionGallery = "photo_access_denied";
      interface.funcOpenDialog(context);
    }


  }

  void init() {
    imagePicker = new DialogSelectPickerImage(listener: this, controller: controller,color: color, );
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    /*File? croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Editar foto',
          toolbarColor: CustomColors.white,
          toolbarWidgetColor: CustomColors.graytext,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      /* aspectRatio: CropAspectRatio(
          ratioX: 1.0,
          ratioY: 1.0),*/
      maxWidth: 512,
      maxHeight: 512,
    );
    listener.userImage(croppedFile!);*/
  }


  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}

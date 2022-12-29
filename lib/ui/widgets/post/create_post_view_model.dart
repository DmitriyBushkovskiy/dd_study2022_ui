import 'dart:io';

import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  var descriptionTec = TextEditingController();


  final BuildContext context;
  CreatePostViewModel({required this.context});

  Future addPhoto() async {

    await Navigator.of(AppNavigator.key.currentState!.context).
    push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(newContext).pop();
            return false;
          },
          child: SafeArea(
            child: CamWidget(
              shape: CameraShape.square,
              onFile: (file) {
                imagesWithPath.add(ImageWithPath(
                    path: file.path,
                    image: Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                    )));
                notifyListeners();
              },
            ),
          ),
        ),
      ),
    ));
  }

  List<ImageWithPath> selectedImages = [];

  void selectImage(ImageWithPath image) {
    selectedImages.add(image);
    notifyListeners();
  }

  void unselectImage(ImageWithPath image) {
    selectedImages.remove(image);
    notifyListeners();
  }

  List<ImageWithPath> imagesWithPath = [];

  void removeSelected() {
    for (var image in selectedImages) {
      imagesWithPath.remove(image);
    }
    selectedImages.clear();
    notifyListeners();
  }

  void createPost() async {
    var files = imagesWithPath.map((e) => File(e.path)).toList();
    var attachMeta = await _api.uploadTemp(files: files);

    await _api
        .createPost(CreatePostModel(
            content: attachMeta, description: descriptionTec.text))
        .then((value) {
      imagesWithPath.clear();
      descriptionTec.clear();
      notifyListeners();
    });
  }
}

class ImageWithPath {
  String path;
  Image image;

  ImageWithPath({
    required this.path,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageWithPath && other.path == path && other.image == image;
  }

  @override
  int get hashCode => path.hashCode ^ image.hashCode;
}

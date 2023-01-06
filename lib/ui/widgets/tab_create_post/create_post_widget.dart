import 'package:dd_study2022_ui/ui/widgets/tab_create_post/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreatePostViewModel>();
    var size = MediaQuery.of(context).size;
    //TODO: add opportunity to add images from library
    //TODO:make scrollable screen
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Create post"),
        actions: [
          IconButton(
              onPressed: viewModel.imagesWithPath.length < 9
                  ? viewModel.addPhoto
                  : null,
              icon: const Icon(Icons.add_a_photo_outlined)),
          IconButton(
              onPressed: viewModel.selectedImages.isEmpty
                  ? null
                  : viewModel.removeSelected,
              icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.width / 3 * (((viewModel.imagesWithPath.length - 1) ~/ 3) + 1),
            child: GridView.builder(
              itemCount: viewModel.imagesWithPath.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    var selectedImage = viewModel.imagesWithPath[index];
                    if (viewModel.selectedImages.contains(selectedImage)) {
                      viewModel.unselectImage(selectedImage);
                    } else {
                      viewModel.selectImage(selectedImage);
                    }
                  },
                  child:
                      Stack(alignment: AlignmentDirectional.topEnd, children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(1),
                      child: viewModel.imagesWithPath[index].image,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                    ),
                    if (viewModel.selectedImages.isNotEmpty &&
                        !viewModel.selectedImages
                            .contains(viewModel.imagesWithPath[index]))
                      const Icon(
                        Icons.circle_outlined,
                        color: Colors.white,
                      ),
                    if (viewModel.selectedImages
                        .contains(viewModel.imagesWithPath[index]))
                      const Icon(
                        Icons.check_circle_outline_sharp,
                        color: Colors.white,
                      )
                  ]),
                );
              },
            ),
          ),
          if (viewModel.imagesWithPath.isNotEmpty)
            TextField(
              controller: viewModel.descriptionTec,
              maxLength: 2000,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(6),
                hintText: "Enter description",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                ),
              ),
            ),
          if (viewModel.imagesWithPath.isNotEmpty)
            Center(
              child: ElevatedButton(
                  onPressed: viewModel.createPost,
                  child: const Text("Create post")),
            )
        ],
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreatePostViewModel(context: context),
      child: const CreatePostWidget(),
    );
  }
}

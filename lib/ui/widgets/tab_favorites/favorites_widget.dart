import 'package:dd_study2022_ui/ui/widgets/tab_favorites/favorites_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/home/home_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<FavoritesViewModel>();
    var itemCount = viewModel.postFeed?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: viewModel.postFeed == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              controller: viewModel.lvc,
              itemBuilder: (_, listIndex) => PostWidget(
                viewModel: viewModel,
                listIndex: listIndex,
              ),
              separatorBuilder: (context, index) => Container(
                height: 20,
                color: Colors.green,
              ),
              itemCount: itemCount,
            ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavoritesViewModel(context: context),
      child: const FavoritesWidget(),
    );
  }
}

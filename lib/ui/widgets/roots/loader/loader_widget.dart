import 'package:dd_study2022_ui/ui/widgets/roots/loader/loader_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,
      body: Center(child: CircularProgressIndicator()),
    );
  }

  static Widget create() => ChangeNotifierProvider<LoaderViewModel>(
        create: (context) => LoaderViewModel(context: context),
        lazy: false,
        child: const LoaderWidget(),
      );
}
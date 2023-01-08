import 'package:dd_study2022_ui/ui/widgets/common/users_list_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
        appBar: AppBar(actions: <Widget>[
          if (viewModel.isSearching)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          if (viewModel.isSearching)
            Expanded(
              child: TextFormField(
                controller: viewModel.searchTec,
              ),
            ),
          IconButton(
              onPressed: viewModel.isSearching
                  ? viewModel.hideSearchField
                  : viewModel.showSearchField,
              icon: Icon(viewModel.isSearching ? Icons.close : Icons.search))
        ]),
        body: Container(
            child: viewModel.users == null
                ? const Center(child: CircularProgressIndicator())
                : UsersListWidget(
                    relationsViewModel: viewModel,
                    controller: viewModel.lvc,
                    usersList: viewModel.users!,
                  )
            ));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(context: context),
      child: const SearchWidget(),
    );
  }
}
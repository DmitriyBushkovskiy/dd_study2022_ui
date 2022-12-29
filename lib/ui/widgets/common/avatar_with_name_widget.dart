// import 'package:dd_study2022_ui/domain/models/user.dart';
// import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
// import 'package:dd_study2022_ui/ui/widgets/tab_home/home.dart';
// import 'package:flutter/material.dart';

// class AvatarAndNameWidget extends StatelessWidget {
//   //final HomeViewModel viewModel;
//   final User user;
//   final AvatarWidget avatarWidget;

//   const AvatarAndNameWidget({Key? key, required this.viewModel, required this.avatarWidget})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey,
//       child: Row(
//         children: [
//           viewModel.user != null
//               ? avatarWidget
//               : const CircularProgressIndicator(),
//           Container(
//             padding: const EdgeInsets.only(left: 10),
//             child: GestureDetector(
//               //onTap: viewModel.logout, //TODO: remove
//               child: Text(viewModel.user == null
//                   ? "no data"
//                   : viewModel.user!.username),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
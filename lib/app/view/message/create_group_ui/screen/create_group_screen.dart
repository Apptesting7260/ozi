// import 'package:flutter/material.dart';
// import 'package:g_clout_media/Custom/widgets/custom_circular_image_widget.dart';
// import 'package:g_clout_media/core/appExports/app_export.dart';
//
// import '../provider/create_group_provider.dart';
//
//
// class CreateGroupScreen extends StatefulWidget {
//
//   final List<String> members;
//
//   const CreateGroupScreen({super.key, required this.members});
//
//   @override
//   State<CreateGroupScreen> createState() => _CreateGroupScreenState();
// }
//
// class _CreateGroupScreenState extends State<CreateGroupScreen> {
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => CreateGroupProvider(),
//       child: Scaffold(
//         backgroundColor: context.white,
//         appBar: CustomAppBar(
//           title: "Create Group",
//         ),
//         body: Consumer<CreateGroupProvider>(
//           builder: (context, provider, child) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       CircularProfileImage(
//                         imageUrl: provider.profileImage?.path??'',
//                         size: 120,
//                         borderColor: Colors.transparent,
//                       ),
//                       hBox(8),
//                       InkWell(
//                         onTap: () {
//                           showModalBottomSheet(
//                             backgroundColor: context.white,
//                             context: context,
//                             builder: (context) {
//                               return Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ListTile(
//                                     leading: Icon(Icons.camera_alt),
//
//                                     title: Text(
//                                       context.tr?.Editprofile_takephoto ??
//                                           'Take Photo',
//                                       style: AppFontStyle.text_16_400(
//                                         context.black,
//                                       ),
//                                     ),
//
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                       provider.pickImageFromCamera();
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: Icon(Icons.photo_library),
//                                     title: Text(
//                                       context.tr?.Editprofile_pickimage ??
//                                           'Pick Image from Gallery',
//                                       style: AppFontStyle.text_16_400(
//                                         context.black,
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                       provider.pickAndCropSingleImage(
//                                         context,
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: Text(
//                           'Add Group Icon',
//                           style: AppFontStyle.text_16_400(context.primary),
//                         ),
//                       ),
//                     ],
//                   ),
//                   hBox(20),
//
//                   /// Input Fields
//                   Form(
//                     key: provider.formKey,
//                     child: Padding(
//                       padding: REdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Group Name',
//                             style: AppFontStyle.text_18_400(context.titleColor),
//                           ),
//                           hBox(6),
//                           CustomTextFormField(
//                             controller: provider.nameController,
//                             hintText:
//                             "Enter group name",
//                             validator: (password) {
//                               if (password == null || password.isEmpty) {
//                                 return  "Enter group name";
//                               }
//                               return null;
//                             },
//                             onTapOutside:
//                                 (_) =>
//                                 FocusManager.instance.primaryFocus
//                                     ?.unfocus(),
//                             prefix: Padding(
//                               padding: REdgeInsets.only(
//                                 left: 18.w,
//                                 right: 10.w,
//                               ),
//                               child: CustomImage(path: ImageConstants.person),
//                             ),
//                           ),
//
//                           hBox(15),
//                           Text(
//                             'Group Description',
//                             style: AppFontStyle.text_18_400(context.titleColor),
//                           ),
//                           hBox(6),
//                           CustomTextFormField(
//                             textInputAction: TextInputAction.newline,
//                             textInputType: TextInputType.multiline,
//                             minLines: 5,
//                             maxLines: 5,
//                             maxLength: 300,
//                             borderRadius: 25.r,
//                             controller: provider.bioController,
//                             hintText:
//                                 " Write group description...	",
//                             validator: (password) {
//                               if (password == null || password.isEmpty) {
//                                 return "Enter group description	";
//                               }
//                               return null;
//                             },
//                             onTapOutside:
//                                 (_) =>
//                                 FocusManager.instance.primaryFocus
//                                     ?.unfocus(),
//                           ),
//                           hBox(15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               CustomButton(
//                                 width: Get.width() * 0.42,
//                                 forGroundColor: context.primary,
//                                 borderColor: context.primary,
//                                 color: context.white,
//                                 text:
//                                 context.tr?.editprofile_cancelbutton ??
//                                     'Cancel',
//
//                                 //isLoading: controller.isLoading,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               CustomButton(
//                                 width: Get.width() * 0.42,
//                                 text:'Submit',
//                                 isLoading: provider.isLoading,
//                                 onPressed: () {
//                                   if (provider.formKey.currentState!
//                                           .validate()) {
//                                     provider.updateProfile(context,widget.members);
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           hBox(15),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

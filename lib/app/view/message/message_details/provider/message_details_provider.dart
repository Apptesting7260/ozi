

import 'package:ozi/app/core/appExports/app_export.dart';

import '../../../../core/constants/app_urls.dart';
import '../../../../data/models/chat_models/conversion_list_model.dart';
import '../../../../data/models/chat_models/message_list_model.dart';
import '../../../../data/models/chat_models/page_status_model.dart';
import '../../../../data/network/web_socket_connection_service.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/storage/user_preference.dart';
import '../../message_isolates/message_isolates.dart';

import '../../provider/message_provider.dart';

class MessageDetailsProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  SocketController socket = navigatorKey.currentContext!.read<SocketController>();

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int page = 0;
  bool isPagination = true;
  VoidCallback? _scrollListener;

  bool _isNewMessageReceived = false;
  bool get isNewMessageReceived => _isNewMessageReceived;
  updateIsNewMessageReceived(bool value){
    _isNewMessageReceived = value;
    notifyListeners();
  }

  void startScrollListener() {
    if (_scrollListener != null) return;

    _scrollListener = () {
      // Pagination: when reaching top (since reversed = true)
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          isPagination) {
        messageList(null);
      }

      // Check if at bottom (for reversed list: pixels == 0)
      if (scrollController.hasClients) {
        if (scrollController.position.pixels <= 50) {
          // 👇 User is at bottom (latest messages visible)
          updateIsNewMessageReceived(false);
        } else {
          // 👆 User has scrolled up
          // updateIsNewMessageReceived(true);
        }
      }
    };

    // Add listener to controller
    scrollController.addListener(_scrollListener!);
  }


  // void startScrollListener() {
  //   if (_scrollListener != null) return;
  //
  //   _scrollListener = () {
  //     if (scrollController.position.pixels >=
  //             scrollController.position.maxScrollExtent - 200 &&
  //         !isLoading &&
  //         isPagination) {
  //       messageList(null);
  //     }
  //
  //     // Optional: scroll-to-top logic
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (scrollController.hasClients &&
  //           scrollController.position.pixels == 0) {
  //         scrollController.animateTo(
  //           0,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     });
  //   };
  //
  //   scrollController.addListener(_scrollListener!);
  // }

  void removeScrollListener() {
    if (_scrollListener != null) {
      scrollController.removeListener(_scrollListener!);
      _scrollListener = null; // prevent double removal
    }
  }

  // bool showEmojiPicker = false;
  // updateShowEmojiPicker(bool value) {
  //   showEmojiPicker = value;
  //   notifyListeners();
  // }

  FocusNode focusNode = FocusNode();
  //
  // MessageListModelData? selectedMessage;
  // Offset? tapPosition;
  //
  // updateSelectedMessage(MessageListModelData value) {
  //   selectedMessage = value;
  //   notifyListeners();
  // }

  Future<void> rectionOnMessage(String conversionId, String reaction,String msgId) async {
    socket.sendMessage(AppUrls.messageReactionEvent, {
      "messageId": msgId,
      "conversationId": conversionId,
      "reaction": reaction,
    });
  }

  Future<void> deleteAMessage(String messageId, String conversationId) async {
    socket.sendMessage(AppUrls.deleteMsgEvent, {
      "messageId": messageId,
      "conversationId": conversationId,
    });
  }

  String? userId;

  Future<void> getUserId() async {
    userId = await UserPreference.returnUserId() ?? '';
  }

  Future<void> receivePersonalMessage() async {
    socket.listenToEvent(AppUrls.receivePersonalMessageEvent, (p0) async {
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        if (data['status'] == true) {
          data['data']['senderType'] = "sender";
          // MessageListModelData receiveData = MessageListModelData.fromJson(data['data']);
          MessageListModelData receiveData = await parseMessageListInBackground(
            data['data'],
          );
          if (messageListData.data?.data.any((e) => e.sId == receiveData.sId) ==
              false) {
            // messageListData.data?.data.insert(0,MessageListModelData.fromJson(data['data']));
            messageListData.data?.data.insert(
              0,
              await parseMessageListInBackground(data['data']),
            );
            updateLastMessageOfConversation(receiveData.text??'',receiveData.conversationId??'');
            if(scrollController.hasClients){
              if((scrollController.position.pixels>=0)&&(scrollController.position.pixels<50)){
                // updateIsNewMessageReceived(true);
              }else{
                updateIsNewMessageReceived(true);
              }
            }
            notifyListeners();
          }
        }
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });

    socket.listenToEvent(AppUrls.changeMsgStatusEvent, (p0) {
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        if (data['conversationId'] == _conversionId) {
          if (data['status'] == 'delivered') {
            for (
              int i = 0;
              i < (_messageListData.data?.data.length ?? 0);
              i++
            ) {
              if (_messageListData.data?.data[i].status == 'sent') {
                _messageListData.data?.data[i].status = 'delivered';
              }
            }
          } else if (data['status'] == 'seen') {
            for (
              int i = 0;
              i < (_messageListData.data?.data.length ?? 0);
              i++
            ) {
              if (_messageListData.data?.data[i].status == 'sent' ||
                  _messageListData.data?.data[i].status == 'delivered') {
                _messageListData.data?.data[i].status = 'seen';
              }
            }
          }
          notifyListeners();
        }
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });

    socket.listenToEvent(AppUrls.updateMessageEvent, (p0) async {
      if (kDebugMode) {
        print('message deleted with data $p0');
      }
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        if (data['data'] != null) {
          // MessageListModelData? updatedData = MessageListModelData.fromJson(data['data']);
          MessageListModelData? updatedData =
              await parseMessageListInBackground(data['data']);

          final index = _messageListData.data?.data.indexWhere(
            (item) => item.sId == updatedData.sId,
          );

          if (index != null && index != -1) {
            // Replace the item at the matching index
            _messageListData.data?.data[index] = updatedData;
          } else {
            // Optional: add it if it doesn't exist
            _messageListData.data?.data.add(updatedData);
          }
          notifyListeners();
                }
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });

    socket.listenToEvent(AppUrls.deleteMsgEvent, (p0) {
      if (kDebugMode) {
        print('message deleted with data $p0');
      }
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        if (data['status'] == true) {
          _messageListData.data?.data.removeWhere(
            (e) => e.sId == data['messageId'],
          );
          notifyListeners();
        }
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });
  }


  void updateLastMessageOfConversation(String? lastMessage, String convId) {
    if (kDebugMode) {
      print('Trying to update last message: $lastMessage for conversation: $convId');
    }

    final messageProvider = navigatorKey.currentContext?.read<MessageProvider>();
    if (messageProvider == null) {
      if (kDebugMode) {
        print('MessageProvider not available in current context.');
      }
      return;
    }

    final conversations = messageProvider.allConversionData.data?.data;
    if (conversations == null) return;

    for (var conv in conversations) {
      if (conv.sId == convId) {
        // Safely update the last message
        if (conv.lastMessage != null) {
          conv.lastMessage!.text = lastMessage;
        } else {
          // Handle case where lastMessage is null
          conv.lastMessage = LastMessage(text: lastMessage);
        }
        break;
      }
    }

    // 👇 make sure UI updates
    messageProvider.notifyListeners();
  }

  // updateLastMessageOfConversation(String? lastMessage,String convId){
  //   print('trying to update last message $lastMessage $convId');
  //   navigatorKey.currentContext!.read<MessageProvider>().allConversionData.data?.data?.forEach((e){
  //       if(e.sId==convId){
  //         e.lastMessage?.text=lastMessage;
  //       };
  //   });
  // }

  scrollToBottom(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    updateIsNewMessageReceived(false);
  }

  //change_page_status

  PageStatusModel? _userData;
  PageStatusModel? get userData => _userData;
  updateUserData(PageStatusModel? value) {
    _userData = value;
    notifyListeners();
  }

  Future<void> changePageStatus(String? conversionId,{String? messageForSend,String? dataLink}) async {
    await getUserId();
    socket.sendMessage(AppUrls.changePageStatusEvent, {
      "conversationId": conversionId ?? '',
    });

    socket.listenToEvent(AppUrls.changePageStatusEvent, (p0) async {
      socket.off(AppUrls.changePageStatusEvent);
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        // updateUserData(PageStatusModel.fromJson(data));
        updateUserData(await parsePageStatusModelInBackground(data));
        messageList(conversionId,dataLink: dataLink,messageForSend: messageForSend);
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });
  }

  //message_list

  ApiResponse<MessageListModel> _messageListData = ApiResponse.loading();
  ApiResponse<MessageListModel> get messageListData => _messageListData;
  updateMessageListData(ApiResponse<MessageListModel> value) {
    _messageListData = value;
    notifyListeners();
  }

  String? _conversionId;

  Future<void> messageList(String? conversionId1,{String? messageForSend,String? dataLink}) async {
    isLoading = true;
    if (conversionId1 != null) {
      _conversionId = conversionId1;
    }
    page++;
    await getUserId();
    socket.sendMessage(AppUrls.messageListEvent, {
      "conversationId": conversionId1 ?? _conversionId ?? '',
      "page": page,
      "limit": 10, //page = 1, limit = 10
    });

    socket.listenToEvent(AppUrls.messageListEvent, (p0) async {
      socket.off(AppUrls.messageListEvent);
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        if (kDebugMode) {
          print('page is $page');
        }
        if (page == 1) {
          // updateMessageListData(ApiResponse.completed(MessageListModel.fromJson(data)));
          updateMessageListData(
            ApiResponse.completed(await parseMessageDataInBackground(data)),
          );
          if (kDebugMode) {
            print('message for send and data links are $messageForSend $dataLink');
          }
          if(messageForSend!=null||dataLink!=null){
            if (kDebugMode) {
              print('sending personal message for links');
            }
            sendPersonalMessage(conversionId1!,message:messageForSend,dataLink:dataLink);
          }
        } else {
          MessageListModel parsedData = await parseMessageDataInBackground(
            data,
          );
          List<MessageListModelData>? lists = parsedData.data;
          _messageListData.data?.data.addAll(lists);
          if (lists.isEmpty) {
            isPagination = false;
          }
          //isPagination
          notifyListeners();
        }
        isLoading = false;
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });
  }

  Future<void> sendPersonalMessage(
    String conversationId, {
    List<String>? files,
    MessageListModelData? currentMessageIs,
    String? message,
    String? dataLink,
  }) async {
    // if(sendLoading) return;
    if (kDebugMode) {
      print('send message called start');
    }

    // if (controller.text.isEmpty && (files?.isEmpty ?? [].isEmpty)) return;
    if ((controller.text.isEmpty) &&
        (files == null || files.isEmpty) &&
        (message == null || message.isEmpty) &&
        (dataLink == null || dataLink.isEmpty)) {
      if (kDebugMode) {
        print('Nothing to send, returning...');
      }
      return;
    }
    MessageListModelData? currentMessageIs0 = currentMessageIs;

    if (files == null || files.isEmpty) {
      currentMessageIs0 = MessageListModelData(
        text: message??controller.text,
        senderId: userId,
        status: 'waiting',
        sId: "$conversationId${controller.text}",
        createdAt: DateTime.now().toIso8601String(),
        fileUrl: files ?? [],
        senderType: 'you',
        dataLink:dataLink,
        mediaUploadLoading: true,
      );
      if(dataLink==null){
        messageListData.data?.data.insert(0, currentMessageIs0);
      }
      notifyListeners();
      controller.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    // updateSendLoading(true);
    socket.sendMessage(AppUrls.sendPersonalMessageEvent, {
      "senderId": userId,
      "conversationId": conversationId,
      "message": currentMessageIs0?.text ?? '',
      "dataLink":dataLink,
      "file": files ?? [],
    });

    socket.listenToEvent(AppUrls.sendPersonalMessageEvent, (p0) async {
      socket.off(AppUrls.sendPersonalMessageEvent);
      // updateSendLoading(false);
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;

        if (data['status'] == true) {
          data['data']['senderType'] = "you";
          messageListData.data?.data.removeWhere(
            (e) => e.sId == '$conversationId${currentMessageIs0?.text}',
          );
          messageListData.data?.data.insert(
            0,
            await parseMessageListInBackground(data['data']),
          );

          notifyListeners();
        }
        if (kDebugMode) {
          print("data Map is $data");
        }
      }
    });
  }

  // Repository _repo = Repository();
  //
  // Future<File?> compressVideo(File file) async {
  //   try {
  //     final info = await VideoCompress.compressVideo(
  //       file.path,
  //       quality: VideoQuality.MediumQuality, // Instagram style
  //       deleteOrigin: false,
  //       includeAudio: true,
  //     );
  //     return info?.file;
  //   } catch (e) {
  //     print("Video compression failed: $e");
  //     return file;
  //   }
  // }
  //
  // // Compress image
  // Future<Uint8List> compressImage(File file) async {
  //   try {
  //     final result = await FlutterImageCompress.compressWithFile(
  //       file.path,
  //       quality: 70, // Reduce size to ~70% quality
  //       rotate: 0,
  //     );
  //     return result ?? file.readAsBytesSync();
  //   } catch (e) {
  //     print("Image compression failed: $e");
  //     return file.readAsBytesSync();
  //   }
  // }

  // ChatFilePresignedUrlsModel? preSignedUrl;
  //
  // // Modified sendImagesOrVideosOrFiles
  // Future<void> sendImagesOrVideosOrFiles(
  //   List<File> files,
  //   UploadFileType type,
  // ) async {
  //   List<Uint8List> bytesList = [];
  //
  //   for (File file in files) {
  //     if (type == UploadFileType.video) {
  //       File? compressedVideo = await compressVideo(file);
  //       bytesList.add(await compressedVideo!.readAsBytes());
  //     } else if (type == UploadFileType.image) {
  //       bytesList.add(await compressImage(file));
  //     } else {
  //       bytesList.add(await file.readAsBytes());
  //     }
  //   }
  //
  //   MessageListModelData _currentMessageIs = MessageListModelData(
  //     text: controller.text,
  //     senderId: userId,
  //     status: 'waiting',
  //     sId: "$_conversionId${controller.text}",
  //     createdAt: DateTime.now().toIso8601String(),
  //     fileUrl: preSignedUrl?.publicUrls ?? [],
  //     senderType: 'you',
  //     mediaUploadLoading: true,
  //   );
  //
  //   messageListData.data?.data.insert(0, _currentMessageIs);
  //   controller.clear();
  //   notifyListeners();
  //   String? audioExt;
  //   if(type==UploadFileType.audio){
  //     audioExt = path.extension(files[0].path).replaceAll('.', '');
  //   }
  //   await getPresignedUrl(
  //     type.name == 'image/jpeg'
  //         ? 'image'
  //         : type.name == 'video/mp4'
  //         ? 'video'
  //         : type.name,//+"/${path.extension(files[0].path).replaceAll('.', '')}",
  //     files.length,
  //       audioExt
  //   );
  //
  //   await uploadFiles(preSignedUrl?.uploadUrls ?? [], bytesList, type);
  //   sendPersonalMessage(
  //     _conversionId ?? '',
  //     files: preSignedUrl?.publicUrls ?? [],
  //     currentMessageIs: _currentMessageIs,
  //   );
  // }

  // Future<void> sendImagesOrVideosOrFiles(List<Uint8List> files,UploadFileType type)async {
  //   MessageListModelData _currentMessageIs = MessageListModelData(
  //       text: controller.text,
  //       senderId: userId,
  //       status: 'waiting',
  //       sId: "$_conversionId${controller.text}",
  //       createdAt: DateTime.now().toIso8601String(),
  //       fileUrl: preSignedUrl?.publicUrls??[],
  //       senderType: 'you',
  //       mediaUploadLoading: true
  //   );
  //   messageListData.data?.data.insert(0,_currentMessageIs);
  //   controller.clear();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController.hasClients) {
  //       scrollController.animateTo(
  //         0,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  //   notifyListeners();
  //   await getPresignedUrl(type.name=='image/jpeg'?'image':type.name=='video/mp4'?'video':type.name,files.length);
  //  await uploadFiles(preSignedUrl?.uploadUrls??[],files,type);
  //   sendPersonalMessage(_conversionId??'',files: preSignedUrl?.publicUrls??[],currentMessageIs: _currentMessageIs);
  // }

  // Future<void> pickFile() async {
  //   try {
  //     // Pick any file type
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.any,
  //       allowMultiple: false,
  //     );
  //
  //     if (result != null && result.files.single.path != null) {
  //       File file = File(result.files.single.path!);
  //
  //       // Get file extension/type
  //       String? extension = result.files.single.extension?.toLowerCase();
  //
  //       String fileType = 'unknown';
  //       if (extension != null) {
  //         if (['jpg', 'jpeg', 'png', 'svg', 'gif'].contains(extension)) {
  //           fileType = 'image';
  //         } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
  //           fileType = 'video';
  //         } else if (['mp3', 'wav', 'aac', 'm4a'].contains(extension)) {
  //           fileType = 'audio';
  //         } else {
  //           fileType = 'file';
  //         }
  //       }
  //
  //       print('file is $file file type is $fileType');
  //       Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(
  //           builder:
  //               (context) => FilePreviewScreen(
  //                 file: file,
  //                 fileType: fileType,
  //                 onSend: (File file, String fileType) {
  //                   sendImagesOrVideosOrFiles(
  //                     [file],
  //                     fileType == 'image'
  //                         ? UploadFileType.image
  //                         : fileType == 'video'
  //                         ? UploadFileType.video
  //                         : UploadFileType.audio,
  //                   );
  //                 },
  //               ),
  //         ),
  //       );
  //       // return {
  //       //   'file': file,
  //       //   'type': fileType,
  //       // };
  //     }
  //   } catch (e) {
  //     print('Error picking file: $e');
  //   }
  //
  //   return null;
  // }
  //
  // Future<void> getPresignedUrl(String fileType, int noOfFiles,String? audioExt) async {
  //   try {
  //     ChatFilePresignedUrlsModel? value = await _repo
  //         .getPresignedUrlForListFilesChat(fileType, noOfFiles,audioExt);
  //     preSignedUrl = value;
  //   } catch (e) {
  //     Get.showToast(e.toString(), type: ToastType.error);
  //   }
  // }
  //
  // Future<void> uploadFiles(
  //   List<String> urls,
  //   List<Uint8List> files,
  //   UploadFileType type,
  // ) async {
  //   for (int i = 0; i < urls.length; i++) {
  //     if (i >= files.length) break;
  //     final Uint8List imageBytes = files[i];
  //     await _repo.uploadFile(
  //       fileBytes: imageBytes,
  //       uploadUrl: urls[i],
  //       fileType: type,
  //     );
  //   }
  // }

  @override
  void dispose() {
    // Dispose text controller

    // Dispose scroll controller and remove listeners
    removeScrollListener();
    scrollController.dispose();

    // Dispose focus node
    focusNode.dispose();

    // Clear selected message
    // selectedMessage = null;

    // Turn off all socket listeners to avoid memory leaks
    try {
      socket.off(AppUrls.receivePersonalMessageEvent);
      socket.off(AppUrls.changeMsgStatusEvent);
      socket.off(AppUrls.updateMessageEvent);
      socket.off(AppUrls.deleteMsgEvent);
      socket.off(AppUrls.changePageStatusEvent);
      socket.off(AppUrls.messageListEvent);
      socket.off(AppUrls.sendPersonalMessageEvent);
    } catch (e) {
      if (kDebugMode) {
        print("Error disposing socket listeners: $e");
      }
    }
    controller.dispose();
    super.dispose();
  }
}

// class FilePreviewScreen extends StatefulWidget {
//   final File file;
//   final String fileType; // 'image', 'video', 'audio', 'file'
//   final void Function(File file, String fileType)? onSend;
//
//   const FilePreviewScreen({
//     super.key,
//     required this.file,
//     required this.fileType,
//     this.onSend,
//   });
//
//   @override
//   State<FilePreviewScreen> createState() => _FilePreviewScreenState();
// }



// class _FilePreviewScreenState extends State<FilePreviewScreen> {
//   VideoPlayerController? _videoController;
//   AudioPlayer? _audioPlayer;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.fileType == 'video') {
//       _videoController = VideoPlayerController.file(widget.file)
//         ..initialize().then((_) {
//           setState(() {});
//           _videoController!.play();
//         });
//     }
//
//     if (widget.fileType == 'audio') {
//       _audioPlayer = AudioPlayer();
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _audioPlayer?.dispose();
//     super.dispose();
//   }
//
//   void _toggleAudio() async {
//     if (_isPlaying) {
//       await _audioPlayer?.pause();
//     } else {
//       await _audioPlayer?.play(DeviceFileSource(widget.file.path));
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Preview File')),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: _buildFilePreview(),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.send),
//                 label: const Text('Send'),
//                 onPressed: () {
//                   if (widget.onSend != null) {
//                     widget.onSend!(widget.file, widget.fileType);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilePreview() {
//     switch (widget.fileType) {
//       case 'image':
//         return Image.file(widget.file, fit: BoxFit.contain);
//
//       case 'video':
//         if (_videoController != null && _videoController!.value.isInitialized) {
//           return AspectRatio(
//             aspectRatio: _videoController!.value.aspectRatio,
//             child: VideoPlayer(_videoController!),
//           );
//         } else {
//           return const CircularProgressIndicator();
//         }
//
//       case 'audio':
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               iconSize: 80,
//               icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
//               onPressed: _toggleAudio,
//             ),
//             const SizedBox(height: 16),
//             Text(widget.file.path.split('/').last),
//           ],
//         );
//
//       default:
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.insert_drive_file, size: 80),
//             const SizedBox(height: 16),
//             Text(widget.file.path.split('/').last),
//           ],
//         );
//     }
//   }
// }


// class _FilePreviewScreenState extends State<FilePreviewScreen> {
//   VideoPlayerController? _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.fileType == 'video') {
//       _videoController = VideoPlayerController.file(widget.file)
//         ..initialize().then((_) {
//           setState(() {});
//           _videoController!.play();
//         });
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Preview File')),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: _buildFilePreview(),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.send),
//                 label: const Text('Send'),
//                 onPressed: () {
//                   if (widget.onSend != null) {
//                     widget.onSend!(widget.file, widget.fileType);
//                   }
//                   Navigator.pop(context); // optional: close after send
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilePreview() {
//     switch (widget.fileType) {
//       case 'image':
//         return Image.file(widget.file, fit: BoxFit.contain);
//
//       case 'video':
//         if (_videoController != null && _videoController!.value.isInitialized) {
//           return AspectRatio(
//             aspectRatio: _videoController!.value.aspectRatio,
//             child: VideoPlayer(_videoController!),
//           );
//         } else {
//           return const CircularProgressIndicator();
//         }
//
//       case 'audio':
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.audiotrack, size: 80),
//             const SizedBox(height: 16),
//             Text(widget.file.path.split('/').last),
//           ],
//         );
//
//       default: // other files
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.insert_drive_file, size: 80),
//             const SizedBox(height: 16),
//             Text(widget.file.path.split('/').last),
//           ],
//         );
//     }
//   }
// }

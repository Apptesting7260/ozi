import 'package:flutter/foundation.dart';
import '../../../data/models/chat_models/conversion_list_model.dart';
import '../../../data/models/chat_models/message_list_model.dart';
import '../../../data/models/chat_models/page_status_model.dart';

Future<ConversionListModelData> parseConversationListInBackground(
  Map<String, dynamic> json,
) async {
  return compute(_parseConversationList, json);
}

ConversionListModelData _parseConversationList(Map<String, dynamic> json) {
  return ConversionListModelData.fromJson(json);
}

Future<ConversionListModel> parseConversationModelInBackground(
  Map<String, dynamic> json,
) async {
  return compute(_parseConversationModel, json);
}

ConversionListModel _parseConversationModel(Map<String, dynamic> json) {
  return ConversionListModel.fromJson(json);
}

//Message Details isoLates

Future<MessageListModelData> parseMessageListInBackground(
  Map<String, dynamic> json,
) async {
  return compute(_parseMessageList, json);
}

MessageListModelData _parseMessageList(Map<String, dynamic> json) {
  return MessageListModelData.fromJson(json);
}

Future<MessageListModel> parseMessageDataInBackground(
  Map<String, dynamic> json,
) async {
  return compute(_parseMessageData, json);
}

MessageListModel _parseMessageData(Map<String, dynamic> json) {
  return MessageListModel.fromJson(json);
}

Future<PageStatusModel> parsePageStatusModelInBackground(
  Map<String, dynamic> json,
) async {
  return compute(_parsePageStatusModel, json);
}

PageStatusModel _parsePageStatusModel(Map<String, dynamic> json) {
  return PageStatusModel.fromJson(json);
}

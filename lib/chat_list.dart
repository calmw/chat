import 'package:json_annotation/json_annotation.dart';

part 'chat_list.g.dart';

@JsonSerializable()
class ChatList {
  final String? id;
  final String? name;
  final String? avatar;
  final int? groutType;
  final int? notReadMsgNo;
  final String? latestMsg;
  final int? latestMsgType;
  final int? latestMsgTime;

  const ChatList({
    this.id,
    this.name,
    this.avatar,
    this.groutType,
    this.notReadMsgNo,
    this.latestMsg,
    this.latestMsgType,
    this.latestMsgTime,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) =>
      _$ChatListFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListToJson(this);
}

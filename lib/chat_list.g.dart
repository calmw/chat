// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatList _$ChatListFromJson(Map<String, dynamic> json) => ChatList(
      id: json['id'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      groutType: (json['groutType'] as num?)?.toInt(),
      notReadMsgNo: (json['notReadMsgNo'] as num?)?.toInt(),
      latestMsg: json['latestMsg'] as String?,
      latestMsgType: (json['latestMsgType'] as num?)?.toInt(),
      latestMsgTime: (json['latestMsgTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatListToJson(ChatList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'groutType': instance.groutType,
      'notReadMsgNo': instance.notReadMsgNo,
      'latestMsg': instance.latestMsg,
      'latestMsgType': instance.latestMsgType,
      'latestMsgTime': instance.latestMsgTime,
    };

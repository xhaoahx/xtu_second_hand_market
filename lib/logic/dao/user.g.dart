// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String,
    avatarUrl: json['avatarUrl'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };

LocalUser _$LocalUserFromJson(Map<String, dynamic> json) {
  return LocalUser(
    name: json['name'] as String,
    avatarUrl: json['avatarUrl'] as String,
    id: json['id'] as int,
    sid: json['sid'] as String,
    password: json['password'] as String,
    phoneNum: json['phoneNum'] as String,
    qqNum: json['qqNum'] as String,
    wxNum: json['wxNum'] as String,
    onlineWay: json['onlineWay'] as int,
    dormitory: json['dormitory'] as int,
    grade: json['grade'] as int,
  );
}

Map<String, dynamic> _$LocalUserToJson(LocalUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'sid': instance.sid,
      'password': instance.password,
      'grade': instance.grade,
      'dormitory': instance.dormitory,
      'phoneNum': instance.phoneNum,
      'onlineWay': instance.onlineWay,
      'qqNum': instance.qqNum,
      'wxNum': instance.wxNum,
    };

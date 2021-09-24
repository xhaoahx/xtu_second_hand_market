import 'package:json_annotation/json_annotation.dart';
import '../common/json_serializable.dart' as internal;

part 'user.g.dart';

@JsonSerializable()
class User extends internal.JsonSerializable {
  User({
    this.id,
    this.name,
    this.avatarUrl,
  });

  final int id;
  final String name;
  final String avatarUrl;

  Map<String, dynamic> toJson() => _$UserToJson(this);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable()
class LocalUser extends User with internal.JsonSerializable {
  LocalUser({
    String name,
    String avatarUrl,
    int id,
    this.sid,
    this.password,
    this.phoneNum,
    this.qqNum,
    this.wxNum,
    this.onlineWay,
    this.dormitory,
    this.grade,
  }) : super(id: id, name: name, avatarUrl: avatarUrl);

  final String sid;
  final String password;
  final int grade;
  final int dormitory;
  final String phoneNum;
  final int onlineWay;
  final String qqNum;
  final String wxNum;

  Map<String, dynamic> toJson() => _$LocalUserToJson(this);
  factory LocalUser.fromJson(Map<String, dynamic> json) =>
      _$LocalUserFromJson(json);
}

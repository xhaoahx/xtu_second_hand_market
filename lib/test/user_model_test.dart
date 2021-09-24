import '../logic/dao/user.dart';

const String avatarUrl = 'https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1107263072,1224997471&fm=26&gp=0.jpg';


LocalUser yieldLocalUser(){
  return LocalUser(
    sid: 'dlajsdlaj',
    password: 'dalsjdjal',
    avatarUrl: avatarUrl,
    name: '这是登录的用户',
  );
}
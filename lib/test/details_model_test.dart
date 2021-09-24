import 'dart:math' as math;

import 'package:xtusecondhandmarket/logic/dao/comment.dart';
import 'package:xtusecondhandmarket/logic/dao/goods_details.dart';
import 'package:xtusecondhandmarket/logic/dao/user.dart';

const List<String> imgUrls = [
  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585808560941&di=28a876854d67eb75016e418dbf2be912&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F07%2F20150507214556_JYinM.thumb.1000_0.jpeg',
  'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4205037765,718900868&fm=26&gp=0.jpg',
  'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3157557888,4013237088&fm=26&gp=0.jpg'
];
const String avatarUrl = 'https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1107263072,1224997471&fm=26&gp=0.jpg';

final math.Random random = math.Random.secure();

FullGoodsDetails yieldFullGoodsDetails([int id]) {
  id ??= random.nextInt(255);

  return FullGoodsDetails(
    isNew: true,
    imgUrls: List<String>.generate(
      2 + random.nextInt(4),
      (index) => imgUrls[random.nextInt(3)],
      growable: false,
    ),
    oldPrice: '20',
    newPrice: '12',
    title: '这是一个测试商品',
    classification: random.nextInt(6),
    type: random.nextInt(4),
    grade: 1,
    dormitory: 1,
    purchaseWay: 0,
    canBargain: true,
    description: '''
  This is a goods test for goods detials description This is a goods test for goods detials description,
This is a goods test for goods detials description,This is a goods test for goods detials description  
''',
    phoneNum: '13257495609',
    onlineWay: 0,
    onlineNum: '2729232941',
    publishDate: '2020-04-28',
    id: id,
  );
}

User yieldPublisher(int id) {
  return User(
    name:
        'test user [this part is used to check whther overflow is work corectly]',
    avatarUrl: avatarUrl,
  );
}

User yieldCommenter(int id) {
  return User(
    id: id,
    name: 'commenter $id ',
    avatarUrl: avatarUrl,
  );
}

// we most have secondary child comment
List<Comment> yieldComments({bool recursively = true, depth = 0}) {
  if (depth < 2) {
    return List<Comment>.generate(random.nextInt(10 - 6 * depth), (index) {
      final User commenter = yieldCommenter(random.nextInt(5));
      final result = Comment(
        depth: depth,
        children: yieldComments(recursively: false, depth: depth + 1),
        commenter: commenter,
        content: 'depth: $depth comment from ${commenter.name}\n',
      );
      return result;
    });
  } else {
    return <Comment>[];
  }
}

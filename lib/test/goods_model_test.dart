import 'dart:math' as math;
import '../logic/model/global_goods_model.dart';

final math.Random random = math.Random.secure();

Iterable<ShortGoodsDetails> yieldRandomGoodsDetailsShort(int num) sync* {
  for(int i = 0;i < num; i += 1){
    yield ShortGoodsDetails(
      isNew: true,
      imgUrl:'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585808560941&di=28a876854d67eb75016e418dbf2be912&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F07%2F20150507214556_JYinM.thumb.1000_0.jpeg',
      oldPrice: '20',
      newPrice: '20',
      title: '这是一个测试商品',
      classification: random.nextInt(6),
      type: random.nextInt(4),
    );
  }
}

List<String> searchHistoryTest = [
  '这',
  '这是',
  '这是一',
  '这是一个'
  '这是一个测',
  '这是一个测试',
  '这是一个测试商',
  '这是一个测试商品',
];
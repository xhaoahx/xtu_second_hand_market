import 'package:xtusecondhandmarket/ui/page/market_page/classification.dart';

const int classificationCount = 6;
const int listTypeCount = 2;

/// # To String function
String purchaseWayToString(int purchaseWay) {
  return purchaseWay == null ? null : _purchaseWayToString[purchaseWay];
}

String isNewToString(bool isNew) => isNew ? '全新' : '二手';

String listTypeToString(int listType){
  assert(listType != null);
  return _listTypeToString[listType];
}

String classificationToString(int classification){
  if(classification == null){
    return null;
  }
  return _classificationToString[classification];
}

String classificationTypeToString(int classification, int type) {
  if(classification == null || type == null){
    return null;
  }
  return _classificationTypeToString[classification][type];
}

String onlineWayToString(int onlineWay){
  assert(onlineWay != null);
  return _onlineWayToString[onlineWay];
}

int typeCountOf(int classification){
  assert(classification != null);
  return _classificationTypeToString[classification].length;
}

List<String> allTypesOf(int classification){
  assert(classification != null);
  return _classificationTypeToString[classification];
}

/// ## Internal
const List<String> _purchaseWayToString = [
  '面交',
  '邮寄',
];

const List<String> _listTypeToString = [
  '最新发布',
  '推荐',
];

const List<String> _classificationToString = [
  '学习相关',
  '生活用品',
  '数码产品',
  '美妆日化',
  '衣物鞋帽',
  '大杂烩',
];

const List<List<String>> _classificationTypeToString = [
  [
    '全部',
    '教辅',
    '文具',
    '课外',
    '其他',
  ],
  [
    '全部',
    '寝室',
    '电器',
    '娱乐',
    '其他',
  ],
  [
    '全部',
    '设备',
    '配件',
    '外设',
    '其他',
  ],
  [
    '全部',
    '美妆',
    '洗护',
    '大牌',
    '其他',
  ],
  [
    '全部',
    '衣物',
    '鞋帽',
    '饰品',
    '其他',
  ],
  [
    '全部',
    '动植物',
    '租借',
    '零食',
    '其他',
  ]
];

const List<String> _onlineWayToString = [
  'QQ','微信',
];

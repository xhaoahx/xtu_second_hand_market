

enum PublishPageSection {
  title,
  description,
  picture,
  // contact
  gradeInfo,
  dormitoryInfo,
  phoneNum,
  onlineWay,
  onlineNum,
  // for focusNode register
  qqNum,
  wxNum,
  // goods info
  oldPrice,
  newPrice,
  classification,
  tag,
  purchaseWay,
}

enum PublishResult {
  emptyTitle,
  emptyDescription,
  emptyPicture,
  emptyPhoneNum,
  emptyOnlineWay,
  emptyQQNum,
  emptyWXNum,
  emptyOldPrice,
  emptyNewPrice,
  emptyTag,
  netError,
  unknownError,
  succeed,
}

String publishResultToString(PublishResult result){
  return  _publishResultToString[result.index];
}

const List<String>  _publishResultToString = [
  '请填写商品标题',
  '请填写商品描述',
  '请选择商品展示图片',
  '请填写电话号码',
  '请填写线上交易方式',
  '请填写QQ号码',
  '请填写微信号码',
  '请填写原价',
  '请填写现价',
  '请填写商品标签',
  '网络错误',
  '未知错误',
  '成功'
];
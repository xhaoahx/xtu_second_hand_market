// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortGoodsDetails _$ShortGoodsDetailsFromJson(Map<String, dynamic> json) {
  return ShortGoodsDetails(
    title: json['title'] as String,
    isNew: json['isNew'] as bool,
    oldPrice: json['oldPrice'] as String,
    newPrice: json['newPrice'] as String,
    classification: json['classification'] as int,
    type: json['type'] as int,
    id: json['id'] as int,
    purchaseWay: json['purchaseWay'] as int,
    imgUrl: json['imgUrl'] as String,
  );
}

Map<String, dynamic> _$ShortGoodsDetailsToJson(ShortGoodsDetails instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imgUrl': instance.imgUrl,
      'oldPrice': instance.oldPrice,
      'newPrice': instance.newPrice,
      'isNew': instance.isNew,
      'purchaseWay': instance.purchaseWay,
      'classification': instance.classification,
      'type': instance.type,
      'id': instance.id,
    };

FullGoodsDetails _$FullGoodsDetailsFromJson(Map<String, dynamic> json) {
  return FullGoodsDetails(
    title: json['title'] as String,
    isNew: json['isNew'] as bool,
    oldPrice: json['oldPrice'] as String,
    newPrice: json['newPrice'] as String,
    classification: json['classification'] as int,
    type: json['type'] as int,
    id: json['id'] as int,
    purchaseWay: json['purchaseWay'] as int,
    imgUrls: (json['imgUrls'] as List)?.map((e) => e as String)?.toList(),
    canBargain: json['canBargain'] as bool,
    description: json['description'] as String,
    publishDate: json['publishDate'] as String,
    dormitory: json['dormitory'] as int,
    grade: json['grade'] as int,
    onlineNum: json['onlineNum'] as String,
    onlineWay: json['onlineWay'] as int,
    phoneNum: json['phoneNum'] as String,
  );
}

Map<String, dynamic> _$FullGoodsDetailsToJson(FullGoodsDetails instance) =>
    <String, dynamic>{
      'title': instance.title,
      'oldPrice': instance.oldPrice,
      'newPrice': instance.newPrice,
      'isNew': instance.isNew,
      'purchaseWay': instance.purchaseWay,
      'classification': instance.classification,
      'type': instance.type,
      'id': instance.id,
      'description': instance.description,
      'publishDate': instance.publishDate,
      'onlineNum': instance.onlineNum,
      'phoneNum': instance.phoneNum,
      'imgUrls': instance.imgUrls,
      'canBargain': instance.canBargain,
      'grade': instance.grade,
      'dormitory': instance.dormitory,
      'onlineWay': instance.onlineWay,
    };

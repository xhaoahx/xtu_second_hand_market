import 'package:json_annotation/json_annotation.dart';
import '../common/json_serializable.dart' as internal;

part 'goods_details.g.dart';

@JsonSerializable()
class ShortGoodsDetails extends internal.JsonSerializable{
  ShortGoodsDetails({
    this.title = '',
    this.isNew = true,
    this.oldPrice = '',
    this.newPrice = '',
    this.classification,
    this.type,
    this.id,
    this.purchaseWay,
    this.imgUrl,
  });

  final String title;
  final String imgUrl;
  final String oldPrice;
  final String newPrice;
  final bool isNew;
  final int purchaseWay;
  final int classification;
  final int type;
  final int id;
  // ui
  @JsonKey(ignore: true)
  bool isFirstBuild = true;

  @override
  Map<String,dynamic> toJson() => _$ShortGoodsDetailsToJson(this);
  factory ShortGoodsDetails.fromJson(Map<String,dynamic> json) => _$ShortGoodsDetailsFromJson(json);
}

@JsonSerializable()
class FullGoodsDetails extends internal.JsonSerializable{
  FullGoodsDetails({
    this.title,
    this.isNew,
    this.oldPrice,
    this.newPrice,
    this.classification,
    this.type,
    this.id,
    this.purchaseWay,
    this.imgUrls,
    this.canBargain = false,
    this.description = '',
    this.publishDate,
    this.dormitory,
    this.grade,
    this.onlineNum,
    this.onlineWay,
    this.phoneNum,
  });

  final String title;
  final String oldPrice;
  final String newPrice;
  final bool isNew;
  final int purchaseWay;
  final int classification;
  final int type;
  final int id;
  final String description;
  final String publishDate;
  final String onlineNum;
  final String phoneNum;
  final List<String> imgUrls;
  final bool canBargain;
  final int grade;
  final int dormitory;
  final int onlineWay;

  @JsonKey(ignore: true)
  bool isFirstBuild;

  Map<String,dynamic> toJson() => _$FullGoodsDetailsToJson(this);
  factory FullGoodsDetails.fromJson(Map<String,dynamic> json) => _$FullGoodsDetailsFromJson(json);
}

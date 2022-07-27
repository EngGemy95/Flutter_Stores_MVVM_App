import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "message")
  String? message;
}

@JsonSerializable()
class CustomerResponse {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "numOfNotification")
  int? numOfNotification;
  CustomerResponse(this.id, this.name, this.numOfNotification);

  //fromJson
  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);
}

@JsonSerializable()
class ContactsResponse {
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "link")
  String? link;
  ContactsResponse(this.phone, this.email, this.link);
  //fromJson
  factory ContactsResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactsResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$ContactsResponseToJson(this);
}

@JsonSerializable()
class AuthenticationResponse extends BaseResponse {
  @JsonKey(name: "customer")
  CustomerResponse? customer;
  @JsonKey(name: "contacts")
  ContactsResponse? contacts;
  AuthenticationResponse(this.customer, this.contacts);

  //fromJson
  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class ForgetPasswordResponse extends BaseResponse {
  @JsonKey(name: "support")
  String? support;

  ForgetPasswordResponse(this.support);

  //fromJson
  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$ForgetPasswordResponseToJson(this);
}

@JsonSerializable()
class ServiceResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "image")
  String? image;

  ServiceResponse(this.id, this.title, this.image);

  //fromJson
  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}

@JsonSerializable()
class BannerResponse {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "link")
  String? link;

  BannerResponse(this.id, this.title, this.image, this.link);

  //fromJson
  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class StoresResponse {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "image")
  String? image;

  StoresResponse(this.id, this.title, this.image);

  //fromJson
  factory StoresResponse.fromJson(Map<String, dynamic> json) =>
      _$StoresResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$StoresResponseToJson(this);
}

@JsonSerializable()
class HomeDataResponse {
  @JsonKey(name: "services")
  List<ServiceResponse>? services;

  @JsonKey(name: "banners")
  List<BannerResponse>? banners;

  @JsonKey(name: "stores")
  List<StoresResponse>? stores;

  HomeDataResponse(this.services, this.banners, this.stores);

  //fromJson
  factory HomeDataResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDataResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$HomeDataResponseToJson(this);
}

@JsonSerializable()
class HomeResponse extends BaseResponse {
  @JsonKey(name: "data")
  HomeDataResponse? data;

  HomeResponse(this.data);

  //fromJson
  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  //toJson
  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

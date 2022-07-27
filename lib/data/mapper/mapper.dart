import 'package:advanced_app/app/constants.dart';
import 'package:advanced_app/data/response/responses.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/app/extensions.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      this?.id.orEmpty() ?? Constants.empty,
      this?.name.orEmpty() ?? Constants.empty,
      this?.numOfNotification.orZero() ?? Constants.zero,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      this?.phone.orEmpty() ?? Constants.empty,
      this?.email.orEmpty() ?? Constants.empty,
      this?.link.orEmpty() ?? Constants.empty,
    );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      this?.customer.toDomain(),
      this?.contacts.toDomain(),
    );
  }
}

extension ForgetPasswordResponseMapper on ForgetPasswordResponse? {
  String toDomain() {
    return this?.support?.orEmpty() ?? Constants.empty;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
    );
  }
}

extension StoreResponseMapper on StoresResponse? {
  Store toDomain() {
    return Store(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
    );
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
      this?.link.orEmpty() ?? Constants.empty,
    );
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain())
                .cast<Service>() ??
            const Iterable.empty())
        .toList();

    List<Store> stores = (this
                ?.data
                ?.stores
                ?.map((storeResponse) => storeResponse.toDomain())
                .cast<Store>() ??
            const Iterable.empty())
        .toList();

    List<BannerAd> banners = (this
                ?.data
                ?.banners
                ?.map((bannerResponse) => bannerResponse.toDomain())
                .cast<BannerAd>() ??
            const Iterable.empty())
        .toList();

    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}

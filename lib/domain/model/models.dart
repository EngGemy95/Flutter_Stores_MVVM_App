//onBoarding Models
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

// this is the class that have the data which transfer from viewModel to View
class SliderViewObject {
  SliderObject sliderObject;
  int numOfSliders;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSliders, this.currentIndex);
}

//login model
class Customer {
  String id;
  String name;
  int numOfNotification;

  Customer(this.id, this.name, this.numOfNotification);
}

class Contacts {
  String phone;
  String email;
  String link;

  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;

  Authentication(this.customer, this.contacts);
}

//Service Model
class Service {
  int id;

  String title;

  String image;

  Service(this.id, this.title, this.image);
}

//Banner Model
class BannerAd {
  int id;

  String title;

  String image;

  String link;

  BannerAd(this.id, this.title, this.image, this.link);
}

//Stores Model
class Store {
  int id;

  String title;

  String image;

  Store(this.id, this.title, this.image);
}

//HomeData Model
class HomeData {
  List<Service> services;

  List<BannerAd> banners;

  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

//Home Model
class HomeObject {
  HomeData homeData;

  HomeObject(this.homeData);
}

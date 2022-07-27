import 'package:advanced_app/data/network/error_handler.dart';
import 'package:advanced_app/data/response/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 minute

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();
  void removeCache(int key);
}

class LocalDataSourceImpl implements LocalDataSource {
  Map<String, CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cacheItem = cacheMap[CACHE_HOME_KEY];

    if (cacheItem != null && cacheItem.isValid(CACHE_HOME_INTERVAL)) {
      // return response from cache
      return cacheItem.data;
    } else {
      //return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeCache(int key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;

  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(expirationTimeInMillisecond) {
    int currentTimeInMillisecond = DateTime.now().millisecondsSinceEpoch;

    bool isCachedValid =
        (currentTimeInMillisecond - cacheTime) <= expirationTimeInMillisecond;

    return isCachedValid;
  }
}

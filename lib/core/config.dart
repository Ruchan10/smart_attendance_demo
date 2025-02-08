// config.dart

class Config {
  static String _homeUrl = 'https://www.github.com';
  static String _splashImage = '';
  static String _loginImage = 'assets/logo/logo.png';
  static bool _isBioEnabled = false;
  static bool _hasInternet = true;
  static bool _isFirstLoad = true;

  static void setHomeUrl(String homeUrl) {
    _homeUrl = homeUrl;
    
  }

  static String getHomeUrl() {
    return _homeUrl;
  }

  static void setSplashImage(String img) {
    _splashImage = img;
  }

  static String getSplashImage() {
    return _splashImage;
  }

  static void setFirstLoad(bool firstLoad) {
    _isFirstLoad = firstLoad;
  }

  static bool getFirstLoad() {
    return _isFirstLoad;
  }

  static void setLoginImage(String img) {
    _loginImage = img;
  }

  static String getLoginImage() {
    return _loginImage;
  }

  static void setBio(bool bio) {
    _isBioEnabled = bio;
  }

  static bool getBio() {
    return _isBioEnabled;
  }

  static void hasInternet(bool net) {
    _hasInternet = net;
  }

  static bool getInternet() {
    return _hasInternet;
  }
}

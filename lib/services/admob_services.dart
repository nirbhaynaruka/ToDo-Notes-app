import 'dart:io';

class AdMobService {

  String getAdMobAppId() {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3856528239276675~6899624383';
    }
    return null;
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3856528239276675/3131576241';
    }
    return null;
  }
  
  String getInterstitialAdId() {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3856528239276675/3621874299';
    }
    return null;
  }

}
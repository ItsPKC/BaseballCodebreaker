import 'dart:core';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get bannerAdUnitId1 => 'ca-app-pub-4788716700673911/5628397900';
  String get bannerAdUnitId2 => 'ca-app-pub-4788716700673911/1689152899';
  String get bannerAdUnitId3 => 'ca-app-pub-4788716700673911/3252187015';
  String get bannerAdUnitId4 => 'ca-app-pub-4788716700673911/6063512177';
  // Interstitials Ads
  // ID Used in List
  // String get intersAdUnitId1 => 'ca-app-pub-4788716700673911/3562784025';
  // String get intersAdUnitId2 => 'ca-app-pub-4788716700673911/7118885657';
  // String get intersAdUnitId3 => 'ca-app-pub-4788716700673911/6735742278';
  // String get intersAdUnitId4 => 'ca-app-pub-4788716700673911/3682010004';
  BannerAdListener get adListener => _adListener;
  final BannerAdListener _adListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression is recorded for a NativeAd.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}

class GetDeviceSize {
  static int get myWidth {
    return ((window.physicalSize.width / window.devicePixelRatio) -
            (window.physicalSize.width / window.devicePixelRatio) % 20)
        .truncate();
  }
}

class Fire {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get getInstance {
    return _firestore;
  }
}

// class FireStorageBucket {
//   final firebase_storage.FirebaseStorage _storage =
//       firebase_storage.FirebaseStorage.instance;
//   firebase_storage.FirebaseStorage get getInstance {
//     return _storage;
//   }
// }
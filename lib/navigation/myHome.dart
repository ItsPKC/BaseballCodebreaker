import 'package:baseballcodebreaker/content/codebreaker.dart';
import 'package:baseballcodebreaker/content/userGuide.dart';
import 'package:baseballcodebreaker/services/ad_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globalVariables.dart';
import '../content/homeScreen.dart';
import '../updateApp.dart';
import 'myDrawer.dart';
import 'homeButtonSet.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

// Ad refresh karne ke liye dispose add karna hai sab me
// @BAND  kare button me

class _MyHomeState extends State<MyHome> {
  //  These 3 lines are used to check the forced crashlytics of application
  // void initState(){
  //   super.initState();
  //   FirebaseCrashlytics.instance.crash();
  // }

  // Interstitial Ads
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  var adUnitIdList = [
    'ca-app-pub-4788716700673911/4574530050',
    'ca-app-pub-4788716700673911/2829052163',
    'ca-app-pub-4788716700673911/1492753911',
    'ca-app-pub-4788716700673911/7009121706',
  ];
  var adUnitIdIndex = 0;

  void _createInterstitialAd() async {
    print('Int ads Index : $adUnitIdIndex starting');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      InterstitialAd.load(
        adUnitId: adUnitIdList[adUnitIdIndex],
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('Int ads $ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            isInterstitialAdsLoadingAttemped = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('InterstitialAd failed to load: $error.');
            print('InterstitialAd failed to load.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= 3) {
              Future.delayed(
                  Duration(seconds: intAdsRefreshTime(adUnitIdIndex + 1)), () {
                _createInterstitialAd();
              });
            }
            isInterstitialAdsLoadingAttemped = true;
          },
        ),
      );
      // ---------------------------------------------------------
      // Send these 7 lines to onAdLoaded after Admob Restriction is over
      if (adUnitIdIndex == 3) {
        print('Int ads Index : $adUnitIdIndex loaded');
        adUnitIdIndex = 0;
      } else {
        adUnitIdIndex += 1;
        print('Int ads Index : $adUnitIdIndex loaded');
      }
      // ---------------------------------------------------------
    } else {
      if (_numInterstitialLoadAttempts <= 3) {
        print('Int ads recheck for load');
        Future.delayed(Duration(seconds: 2), () {
          _createInterstitialAd();
        });
      }
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Int ads onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Int ads $ad onAdDismissedFullScreenContent.');
        ad.dispose();
        Future.delayed(
          Duration(seconds: intAdsRefreshTime(adUnitIdIndex + 1)),
          () {
            print('Waiting for Inters ............');
            _createInterstitialAd();
            print('Waiting for Inters ............Finished');
          },
        );
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Int ads $ad onAdFailedToShowFullScreenContent: $error');
        print('Int ads $ad onAdFailedToShowFullScreenContent:');
        ad.dispose();
        Future.delayed(
          Duration(seconds: intAdsRefreshTime(adUnitIdIndex + 1)),
          () {
            print('Waiting for Inters ............');
            _createInterstitialAd();
            print('Waiting for Inters ............Finished');
          },
        );
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  BannerAd? _banner1;
  var isAdsAvailableB1 = false;
  int _numBanner1Attempts = 0;
  BannerAd? _banner2;
  var isAdsAvailableB2 = false;
  int _numBanner2Attempts = 0;

  // Ads
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context, listen: false);
    adState.initialization.then(
      (status) {
        if (mounted) {
          setState(
            () {
              _banner1 = BannerAd(
                adUnitId: adState.bannerAdUnitId1,
                // ignore: deprecated_member_use
                size: AdSize.smartBanner,
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    _numBanner1Attempts = 0;
                    if (isAdsAvailableB1 == false) {
                      // Not using setState may lead to not showing ads on load completed when it is not showing.
                      // But it may help to avoid many unusual stuff, mainly when
                      // some other widget are active over ads containing page/widget.
                      // -----------------------------------------------------------------
                      // But their is only one banner ads and int ads are managed other way -
                      // that's we can use setState otherwise it's strictly prohobited
                      setState(() {
                        isAdsAvailableB1 = true;
                      });
                    }
                    print('Ads Loaded');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    // print('Ad failed to load - Banner 1 : $error');
                    print('Ad failed to load - Banner 1');
                    if (isAdsAvailableB1 == false) {
                      reloadBanner1() async {
                        if (_numBanner1Attempts <= 2) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner1 - With Internet');
                            Future.delayed(Duration(seconds: bAds1), () {
                              _numBanner1Attempts += 1;
                              _banner1!.load();
                            });
                          } else {
                            print('Ads loading - Banner1 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              reloadBanner1();
                            });
                          }
                        }
                      }

                      reloadBanner1();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              if (showBanner1 == 1) {
                _banner1!.load();
              }
              var w2 = GetDeviceSize.myWidth;
              // 80 for default margin and 20 for internal padding
              var h2 = (0.7 * w2).truncate();
              _banner2 = BannerAd(
                adUnitId: adState.bannerAdUnitId2,
                // ignore: deprecated_member_use
                size: AdSize(
                  height: h2,
                  width: w2,
                ),
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    _numBanner2Attempts = 0;
                    if (isAdsAvailableB2 == false) {
                      // Not using setState may lead to not showing ads on load completed when it is not showing.
                      // But it may help to avoid many unusual stuff, mainly when
                      // some other widget are active over ads containing page/widget.
                      // -----------------------------------------------------------------
                      // But their is only one banner ads and int ads are managed other way -
                      // that's we can use setState otherwise it's strictly prohobited
                      isAdsAvailableB2 = true;
                    }
                    print('Ads Loaded');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    // print('Ad failed to load - Banner 2 : $error');
                    print('Ad failed to load - Banner 2');
                    if (isAdsAvailableB2 == false) {
                      reloadBanner2() async {
                        if (_numBanner2Attempts <= 2) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner2 - With Internet');
                            Future.delayed(Duration(seconds: bAds2), () {
                              _numBanner2Attempts += 1;
                              _banner2!.load();
                            });
                          } else {
                            print('Ads loading - Banner2 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              reloadBanner2();
                            });
                          }
                        }
                      }

                      reloadBanner2();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              // In 20 seconds most probably data loading from firebase will be completed
              // It is also true that this ads is not going to show in first attemp
              // So, ad have much time to load
              // It also help to increase admob ads quality
              Future.delayed(Duration(seconds: 20), () {
                if (showBanner2 == 1) {
                  _banner2!.load();
                }
              });
            },
          );
        }
      },
    );
  }

  // End Ads

  var myDrawerKey = GlobalKey<ScaffoldState>();
  var pageNumber = 1;
  List<String> bank = [];

  void pageNumberSelector(asd) {
    setState(() {
      pageNumber = asd;
    });
  }

  void setBankName(val) {
    bank = val;
  }

  isAdsAvailableB2Provider() {
    return isAdsAvailableB2;
  }

  _banner2Provider() {
    return _banner2;
  }

  pager(fnc, number) {
    var pageList = [
      // We can't use vacent late variable. late var should have some data on its first use.
      HomeScreen(fnc, isAdsAvailableB1, _banner1),
      // HomeScreen(fnc),
      Codebreaker(
          fnc, _showInterstitialAd, isAdsAvailableB2Provider, _banner2Provider),
      UserGuide(fnc),
    ];
    return pageList[number];
  }

  @override
  void dispose() {
    super.dispose();
    _banner1!.dispose();
    _banner2!.dispose();
  }

  // For checking and Displaying Update Notification

  var isUpdateAvailable = false;

  final FirebaseFirestore _firestore = Fire().getInstance;

  checkForUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    try {
      _firestore.collection('updateApp').get().then(
        (QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            print('======================================== ${doc["version"]}');
            var updatedVersion = '${doc["version"]}';
            var notice = '${doc["notice"]}';
            userGuideData = doc['userGuide'];
            isUserGuideDataFetched = true;
            // Start - Ads Controlled Data
            setAdsData(doc);
            // End - Ads Controller Data
            print(
                'Its verion 00000000000000000000000000000 $updatedVersion $currentVersion');
            print('Its notice ------------------------------- $notice');
            if (updatedVersion != currentVersion) {
              // pageNumberSelector(1);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UpdateApp('${doc["date"]}', '${doc["notice"]}',
                    '${doc["version"]}', '${doc["appLink"]}');
              }));
            }
          }
        },
      );
    } catch (error) {
      print('Update check Error');
    }
  }

  @override
  void initState() {
    super.initState();
    print(_showInterstitialAd);
    _createInterstitialAd();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return Scaffold(
      key: myDrawerKey,
      drawer: MyDrawer(),
      appBar: (pageNumber != 2)
          ? AppBar(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(0, 0, 0, 1),
              ),
              elevation: 3,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: FittedBox(
                      child: Text(
                        'Codebreaker',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          fontFamily: 'Signika',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      height: 36,
                      width: 36,
                      // padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 0.5,
                            spreadRadius: 0.25,
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/logo_edge.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (pageNumber != 1) {
                        setState(
                          () {
                            pageNumberSelector(1);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              leading: Button1(myDrawerKey),
            )
          : AppBar(
              toolbarHeight: 0,
            ),
      body: Container(
        // OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
        key: UniqueKey(),
        child: pager(pageNumberSelector, (pageNumber - 1)),
      ),
    );
  }
}

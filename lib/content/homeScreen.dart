import 'package:baseballcodebreaker/globalVariables.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  final Function pageNumberSelector;
  final isAdsAvailable;
  final _banner1;

  const HomeScreen(this.pageNumberSelector, this.isAdsAvailable, this._banner1,
      {Key? key})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('WA Assist'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.network_check,
                    size: 32,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'No internet  ?',
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                  child: Text(
                    'Retry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 2,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
      Future.delayed(Duration(seconds: 3), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        _checkConnection();
      });
    }
    return false;
  }

  reloadForAds() {
    Future.delayed(Duration(milliseconds: 50), () {
      print('isInterstitialAdsLoading - $isInterstitialAdsLoadingAttemped');

      if (isInterstitialAdsLoadingAttemped == true && mounted) {
        setState(() {
          isInterstitialAdsLoadingAttemped;
        });
      }
      if (isInterstitialAdsLoadingAttemped == false) {
        reloadForAds();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reloadForAds();
    _checkConnection();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        color: Color.fromRGBO(230, 255, 230, 1),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 7.5, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              offset: Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            'assets/grass.png',
                                          ),
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        height:
                                            (MediaQuery.of(context).size.width *
                                                        0.5 -
                                                    30) *
                                                0.6,
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          !(isInterstitialAdsLoadingAttemped),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.8),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        // child: CircularProgressIndicator(
                                        //   color: Color.fromRGBO(230, 0, 0, 1),
                                        // ),
                                        child: CupertinoActivityIndicator(
                                          radius: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  isInterstitialAdsLoadingAttemped
                                      ? 'Codebreaker'
                                      : 'Loading ...',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Signika',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (isInterstitialAdsLoadingAttemped) {
                              widget.pageNumberSelector(2);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(7.5, 0, 15, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              offset: Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/woodentable.jpeg',
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width *
                                                0.5 -
                                            30) *
                                        0.6,
                                    height: (MediaQuery.of(context).size.width *
                                                0.5 -
                                            30) *
                                        0.6,
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      shape: BoxShape.circle,
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: Color.fromRGBO(
                                      //         200, 200, 200, 1),
                                      //     offset: Offset(0, 1),
                                      //     blurRadius: 5,
                                      //   ),
                                      // ],
                                    ),
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.menu_book_rounded,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  'How to use ?',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Signika',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            widget.pageNumberSelector(3);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height <= 400)
                  ? 32
                  : ((MediaQuery.of(context).size.height > 720) ? 90 : 50),
              alignment: Alignment.center,
              // color: Color.fromRGBO(235, 235, 235, 1),
              color: Color.fromRGBO(0, 0, 0, 0.05),
              child: Builder(
                builder: (context) {
                  return (widget.isAdsAvailable == true)
                      ? AdWidget(
                          ad: widget._banner1,
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Ads',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 255, 1),
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

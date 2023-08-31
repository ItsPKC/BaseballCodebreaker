import 'dart:math';

import 'package:baseballcodebreaker/services/ad_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PredictionChart extends StatefulWidget {
  final validCode;
  final signList;
  final Function isAdsAvailableB2Provider, _banner2Provider;
  PredictionChart(this.validCode, this.signList, this.isAdsAvailableB2Provider,
      this._banner2Provider,
      {Key? key})
      : super(key: key);

  @override
  _PredictionChartState createState() => _PredictionChartState();
}

class _PredictionChartState extends State<PredictionChart> {
  var probableValidCode = [];
  var signList = [];
  codeToSignConverter(code) {
    for (int i = 0; i < signList.length; i++) {
      if (signList[i][1] == code) {
        return signList[i][0];
      }
    }
  }

  @override
  void initState() {
    probableValidCode = widget.validCode;
    signList = widget.signList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.validCode);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 10 / 7,
                // child: Container(
                //   width: double.infinity,
                //   color: Colors.amber,
                //   alignment: Alignment.center,
                //   child: Text(
                //       '${widget.isAdsAvailableB2Provider()} \n ${widget._banner2Provider()}'),
                // ),
                child: Container(
                  height: 0.7 * (GetDeviceSize.myWidth - 20).truncate(),
                  // margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  color: Color.fromRGBO(235, 235, 235, 1),
                  child: (widget.isAdsAvailableB2Provider())
                      // it may couse adsense account ban
                      ? AdWidget(
                          ad: widget._banner2Provider(),
                        )
                      : Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Ads',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Signika',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.25,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Divider(
                color: Color.fromRGBO(255, 0, 0, 1),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(5, 18, 5, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: LinearGradient(
                    colors: const [
                      Color.fromRGBO(0, 0, 0, 0.8),
                      Color.fromRGBO(0, 0, 0, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Most Probable Touch',
                        textAlign: TextAlign.justify,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 20,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '[${min(probableValidCode.length, 10)}]',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 22,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(255, 255, 200, 1),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(5),
                  ),
                ),
                // child: Text(
                //   'Pankaj kumar form buxar bihar india.Pankaj kumar form buxar bihar india.Pankaj kumar form buxar bihar india.',
                //   style: TextStyle(
                //     fontFamily: 'Signika',
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //     letterSpacing: 1.5,
                //     height: 1.5,
                //   ),
                // ),
                child: (probableValidCode.isNotEmpty)
                    ? Column(
                        children: [
                          ...probableValidCode.mapIndexed((index, element) {
                            var _elementList = [];
                            for (int i = 0; i < element[0].length; i++) {
                              _elementList
                                  .add(codeToSignConverter(element[0][i]));
                            }
                            return Container(
                              margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0.25),
                                    blurRadius: 0.5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    // alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          ..._elementList.mapIndexed(
                                            (labelIndex, signLabel) => TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: signLabel,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontFamily: 'Signika',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1,
                                                    height: 1.5,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: (labelIndex <
                                                          _elementList.length -
                                                              1)
                                                      ? '  ;  '
                                                      : '',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontFamily: 'Signika',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(235, 255, 235, 1),
                                      // color: Color.fromRGBO(255, 255, 200, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Key : ${element[0]}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        Text(
                                          '${element[3].toStringAsFixed(2)} : 💪',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        // Text(
                                        //   '(+) : ${((element[3] * 100 / element[1])).round().toString()}%',
                                        //   style: TextStyle(
                                        //     color:
                                        //         Color.fromRGBO(36, 14, 123, 1),
                                        //     fontFamily: 'Signika',
                                        //     fontWeight: FontWeight.w600,
                                        //     letterSpacing: 1.5,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.warning_rounded,
                              color: Color.fromRGBO(230, 0, 0, 1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Insufficient data',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5),
                            ),
                          ],
                        ),
                      ),
              ),
              Container(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:isolate';

import 'package:baseballcodebreaker/content/addInputBoardButton.dart';
import 'package:baseballcodebreaker/content/editInputBoard.dart';
import 'package:baseballcodebreaker/content/editInputBoardButton.dart';
import 'package:baseballcodebreaker/content/predictionChart.dart';
import 'package:baseballcodebreaker/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Codebreaker extends StatefulWidget {
  final Function _pageNumberSelector,
      _showInterstitialAd,
      isAdsAvailableB2Provider,
      _banner2Provider;

  Codebreaker(this._pageNumberSelector, this._showInterstitialAd,
      this.isAdsAvailableB2Provider, this._banner2Provider,
      {Key? key})
      : super(key: key);

  @override
  _CodebreakerState createState() => _CodebreakerState();
}

class _CodebreakerState extends State<Codebreaker> {
  var floatingX = 15.0;
  var floatingY = 15.0;
  var inputBoardVisiblity = true;
  var openInputBoard = false;

  // -----------------------------------
  var isCalculationProgress = 0;
  var signList = [];
  var stealStatus = '2'; // 0 - No Steal ; 1 - Steal ; 2 - Waiting to classify
  final ScrollController _controller = ScrollController();
  var currentCombination = [];
  var combinationList = [];
  var inputCode = [];
  var probableValidCode = [];

  forceSetState() {
    setState(() {});
  }

  shiftScrollPosition() {
    Future.delayed(Duration(milliseconds: 10), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  // ------------------------------------------------------------

  getSignList() async {
    // final List? tempSignList = prefs.getStringList('signList');
    // if (tempSignList == null) {
    //   setState(() {
    //     signList.addAll(initialSignList);
    //   });
    //   prefs.setStringList('signList', initialSignList);
    // }

    // prefs.setString('signList', json.encode(initialSignList));

    var tempSignListAsString = prefs.getString('signList');
    if (tempSignListAsString != null) {
      print(
          '=========================================================================');
      print(json.decode('${prefs.getString('signList')}')[0][0].toString());
      var tempSignListAsList = json.decode('${prefs.getString('signList')}');

      for (int i = 0; i < tempSignListAsList.length; i++) {
        for (int j = 0; j < tempSignListAsList[i].length; j++) {
          tempSignListAsList[i][j] = tempSignListAsList[i][j].toString();
          print(tempSignListAsList[i][j]);
        }
      }
      signList.addAll(tempSignListAsList);
    } else {
      signList.addAll(initialSignList);
      prefs.setString('signList', json.encode(initialSignList));
    }
  }

  setSignList() async {
    prefs.setString('signList', json.encode(signList));
  }

  getCombinationList() async {
    var tempCombinationListAsString = prefs.getString('combinationList');
    if (tempCombinationListAsString != null) {
      print(
          '=========================================================================');
      var tempCombinationListAsList =
          json.decode('${prefs.getString('combinationList')}');
      print(tempCombinationListAsList);

      for (int i = 0; i < tempCombinationListAsList.length; i++) {
        print(tempCombinationListAsList[i]);
        tempCombinationListAsList[i][0] =
            tempCombinationListAsList[i][0].toString();
        tempCombinationListAsList[i][1] =
            int.parse(tempCombinationListAsList[i][1].toString());
        // for (int j = 0; j < tempCombinationListAsList[i].length; j++) {
        //   tempCombinationListAsList[i][j] =
        //       tempCombinationListAsList[i][j].toString();
        //   print(tempCombinationListAsList[i][j]);
        // }
      }
      setState(() {
        combinationList.addAll(tempCombinationListAsList);
      });
    }
  }

  setCombinationList(combinationList) async {
    prefs.setString('combinationList', json.encode(combinationList));
  }

  getInputCode() async {}

  setInputCode() async {}

  codeToSignConverter(code) {
    for (int i = 0; i < signList.length; i++) {
      if (signList[i][1] == code) {
        return signList[i][0];
      }
    }
  }

  // ------------------------------------------------------------

  final _isolateList = [];

  startComputing() async {
    setState(() {
      isCalculationProgress += 1;
    });
    // await compute(crackNow, combinationList).then((value) {
    //   print('Computation Completed');
    //   print(value);
    //   print('#################################');
    //   if (mounted) {
    //     // To stop set state, if user pressed back
    //     // Returned after pressing back
    //     probableValidCode = [];
    //     probableValidCode.addAll(value);
    //     setState(() {
    //       probableValidCode;
    //       isCalculationProgress -= 1;
    //     });
    //   }
    // });
    ReceivePort receivePort = ReceivePort();
    Isolate _isolate =
        await Isolate.spawn(crackNow, [receivePort.sendPort, combinationList]);
    _isolateList.add(_isolate);
    receivePort.listen((value) {
      print('Computation Completed');
      print(value);
      print('#####################################');
      if (mounted) {
        // To stop set state, if user pressed back
        // Returned after pressing back
        probableValidCode = [];
        if (combinationList.isNotEmpty) {
          probableValidCode.addAll(value);
        }
        if (isCalculationProgress > 0) {
          isCalculationProgress -= 1;
        } else {
          isCalculationProgress = 0;
        }
        setState(() {
          probableValidCode;
          isCalculationProgress;
        });
      }
    });
  }

  // ------------------------------------------------------------

  // myGrid(name) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       child:Container(
  //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
  //           margin: EdgeInsets.all(2),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: Color.fromRGBO(255, 255, 255, 1),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.grey,
  //                 offset: Offset(0, 0.25),
  //                 blurRadius: 0.5,
  //               )
  //             ],
  //             borderRadius: BorderRadius.circular(3),
  //           ),
  //           child: Text(
  //             name,
  //             textAlign: TextAlign.justify,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: TextStyle(
  //               fontFamily: 'Signika',
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               letterSpacing: 1,
  //             ),
  //           ),
  //       ),
  //       onTap: () {
  //         setState(() {
  //           currentCombination.add(['${Random().nextInt(10)}']);
  //           _controller.jumpTo(_controller.position.maxScrollExtent);
  //         });
  //       },
  //       onLongPress: () {
  //         showDialog(
  //           context: context,
  //           builder: (context) => EditInputBoardButton(
  //             hintText: 'Head',
  //             refresh: forceSetState,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  myGrid(element) {
    return Container(
      margin: EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 0.25),
            blurRadius: 0.5,
          )
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          side: MaterialStateProperty.all(BorderSide.none),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(
            element[0],
            textAlign: TextAlign.justify,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
        onPressed: () {
          if (currentCombination.length < 15) {
            setState(() {
              currentCombination.add(element[1]);
              _controller.jumpTo(_controller.position.maxScrollExtent);
            });
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                contentPadding: EdgeInsets.all(10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Maximum length exceeded',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '15',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(36, 14, 123, 1),
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika',
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'It\'s under Beta. We\'ll come back stronger.',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Signika',
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => EditInputBoardButton(
              element,
              signList,
              forceSetState,
              setSignList,
              combinationList,
              currentCombination,
            ),
          );
        },
      ),
    );
  }

  additionalInputButton(icon, fnc) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 45,
            decoration: BoxDecoration(
              color: Color.fromRGBO(200, 255, 255, 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 0.25),
                  blurRadius: 0.5,
                )
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
            child: icon,
          ),
          onTap: fnc,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget._showInterstitialAd();
    getSignList();
    getCombinationList();
    startComputing();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (inputBoardVisiblity == false) {
          widget._pageNumberSelector(1);
          return false;
        }
        setState(
          () {
            inputBoardVisiblity = false;
            openInputBoard = true;
          },
        );
        return false;
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (inputBoardVisiblity != true) {
                          setState(() {
                            inputBoardVisiblity = true;
                            openInputBoard = false;
                          });
                        }
                      },
                      child: Container(
                        // This color is added to make above gesture responsive
                        color: Colors.transparent,
                        // This box is added to avoid scroll unbounded error in console
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _controller,
                                child: (currentCombination.isNotEmpty)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ...currentCombination.mapIndexed(
                                            (index, element) {
                                              shiftScrollPosition();
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 0, 0, 0),
                                                margin: (index ==
                                                        currentCombination
                                                                .length -
                                                            1)
                                                    ? EdgeInsets.fromLTRB(
                                                        15, 0, 30, 0)
                                                    : EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      codeToSignConverter(
                                                        element,
                                                      ),
                                                      style: TextStyle(
                                                        fontFamily: 'Signika',
                                                        fontSize: 16,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 35,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    240,
                                                                    240,
                                                                    240,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2),
                                                          ),
                                                          child: Text(
                                                            'X',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            currentCombination
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : const EnterCombinationWithBlinker(),
                              ),
                            ),
                            Container(
                              height: 50,
                              // width: 40,
                              padding: EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 32,
                                  ),
                                  Text(
                                    '${currentCombination.length}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w700,
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
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 255, 255, 0.25),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      (stealStatus == '0')
                                          ? Color.fromRGBO(36, 14, 123, 1)
                                          : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'No Steal',
                                    style: TextStyle(
                                      color: (stealStatus == '0')
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(0, 0, 0, 1),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (stealStatus != '0') {
                                        stealStatus = '0';
                                      } else {
                                        stealStatus = '2';
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      (stealStatus == '1')
                                          ? Color.fromRGBO(36, 14, 123, 1)
                                          : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'Steal',
                                    style: TextStyle(
                                      color: (stealStatus == '1')
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(0, 0, 0, 1),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (stealStatus != '1') {
                                        stealStatus = '1';
                                      } else {
                                        stealStatus = '2';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(255, 0, 0, 1),
                              ),
                              side: MaterialStateProperty.all(BorderSide.none),
                            ),
                            child: Text(
                              'Submit & Next',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Signika',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                            onPressed: () async {
                              mySnackBar(data) {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    duration: Duration(
                                      milliseconds: 2000,
                                    ),
                                    content: Text(
                                      data,
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (currentCombination.isNotEmpty) {
                                if (stealStatus == '0' || stealStatus == '1') {
                                  var temp = '';
                                  for (var i = 0;
                                      i < currentCombination.length;
                                      i++) {
                                    temp += currentCombination[i];
                                  }
                                  setState(() {
                                    combinationList
                                        .insert(0, [temp, stealStatus]);
                                    inputCode.add(temp);
                                    currentCombination = [];
                                    stealStatus = '2';
                                    // print(combinationList);
                                  });

                                  // ReceivePort receivePort = ReceivePort();
                                  // await Isolate.spawn((combinationList) {
                                  //   crackNow(combinationList);
                                  // }, receivePort.sendPort);
                                  // receivePort.listen(
                                  //   (message) {
                                  //     print(
                                  //       '#####################################',
                                  //     );
                                  //     print(message);
                                  //   },
                                  // );
                                  await setCombinationList(combinationList);
                                  await startComputing();
                                } else {
                                  mySnackBar('Steal Status is not Selected ??');
                                }
                              } else {
                                mySnackBar('Empty Combination');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Divider(),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      // margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(5),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Color.fromRGBO(0, 0, 0, 0.8),
                                  Color.fromRGBO(0, 0, 0, 1),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Most Probable Touch',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Signika',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                  ),
                                ),
                                (isCalculationProgress > 0)
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$isCalculationProgress',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontSize: 16,
                                              fontFamily: 'Signika',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 8),
                                            child: LinearProgressIndicator(
                                              backgroundColor: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                'more',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontFamily: 'Signika',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Icon(
                                                Icons.double_arrow_rounded,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => PredictionChart(
                                                  probableValidCode,
                                                  signList,
                                                  widget
                                                      .isAdsAvailableB2Provider,
                                                  widget._banner2Provider),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 200, 1),
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
                                      ...((probableValidCode.length > 2)
                                              ? [
                                                  probableValidCode[0],
                                                  probableValidCode[1],
                                                  probableValidCode[2]
                                                ]
                                              : probableValidCode)
                                          .mapIndexed(
                                        (index, element) {
                                          var _elementList = [];
                                          for (int i = 0;
                                              i < element[0].length;
                                              i++) {
                                            _elementList.add(
                                                codeToSignConverter(
                                                    element[0][i]));
                                          }
                                          return Container(
                                            margin: EdgeInsets.fromLTRB(
                                                5, 15, 5, 0),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0, 0.25),
                                                  blurRadius: 0.5,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          ..._elementList
                                                              .mapIndexed(
                                                            (labelIndex,
                                                                    signLabel) =>
                                                                TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      signLabel,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontFamily:
                                                                        'Signika',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        1,
                                                                    height: 1.5,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: (labelIndex <
                                                                          _elementList.length -
                                                                              1)
                                                                      ? ' ; '
                                                                      : '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontFamily:
                                                                        'Signika',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        1,
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
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      fontFamily: 'Signika',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color.fromRGBO(0, 0, 0, 0.8),
                            Color.fromRGBO(0, 0, 0, 1),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Baseball Sign Combination',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Signika',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${combinationList.length}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontFamily: 'Signika',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.delete_forever_rounded,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // if (isCalculationProgress == 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Reset Codebreaker',
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontSize: 22,
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'All of the input sign combinations and results will be deleted permanently.\n',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                            height: 1.4,
                                          ),
                                        ),
                                        Text(
                                          'Are you sure?',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontSize: 16,
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 15, 20),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    230, 0, 0, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Color.fromRGBO(255, 0, 0, 1),
                                              ),
                                            ),
                                            child: Text(
                                              'Reset',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            onPressed: () {
                                              Future.delayed(
                                                  Duration(milliseconds: 150),
                                                  () async {
                                                widget._showInterstitialAd();
                                                for (var _activeIsolate
                                                    in _isolateList) {
                                                  if (_activeIsolate != null) {
                                                    await _activeIsolate.kill();
                                                  }
                                                }
                                                setState(() {
                                                  currentCombination = [];
                                                  combinationList = [];
                                                  inputCode = [];
                                                  probableValidCode = [];
                                                  isCalculationProgress = 0;
                                                });

                                                setCombinationList(
                                                    combinationList);
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                    actionsPadding:
                                        EdgeInsets.fromLTRB(7, 0, 7, 2),
                                  ),
                                );
                                // } else {
                                //   showDialog(
                                //     context: context,
                                //     builder: (context) => AlertDialog(
                                //       content: Text(
                                //           'Processing your Data !!!\n\nPlease Wait ...'),
                                //     ),
                                //   );
                                // }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    (combinationList.isEmpty)
                        ? Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
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
                                  'No data entered',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    ...combinationList.mapIndexed(
                      (index, tempelement) {
                        var element = tempelement[0].toString();
                        var _elementList = [];
                        for (int i = 0; i < element.length; i++) {
                          _elementList.add(codeToSignConverter(element[i]));
                        }
                        return Container(
                          margin: (index < combinationList.length - 1)
                              ? EdgeInsets.fromLTRB(15, 20, 15, 0)
                              : EdgeInsets.fromLTRB(15, 20, 15, 30),
                          decoration: BoxDecoration(
                            color: (tempelement[1].toString() == '1')
                                ? Color.fromRGBO(235, 255, 235, 1)
                                : Color.fromRGBO(255, 235, 235, 1),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0.25),
                                blurRadius: 0.5,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                                                        element.length - 1)
                                                    ? ' -> '
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
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Icon(
                                      Icons.delete_rounded,
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    Future.delayed(Duration(milliseconds: 150),
                                        () async {
                                      setState(() {
                                        combinationList.removeAt(index);
                                        setCombinationList(combinationList);
                                      });
                                      await startComputing();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: inputBoardVisiblity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          childAspectRatio:
                              (MediaQuery.of(context).size.width - 24) /
                                  (3 * 50),
                        ),
                        children: [
                          ...signList
                              .mapIndexed((index, element) => myGrid(element))
                        ],
                      ),
                    ),
                    Container(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              additionalInputButton(
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Scaffold(
                                      body: EditInputBoard(
                                        signList,
                                        forceSetState,
                                        setSignList,
                                        combinationList,
                                        currentCombination,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              additionalInputButton(
                                Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                                () {
                                  // var lastSignCode = signList.last[1];
                                  // var asciiOfLastSignCode =
                                  //     lastSignCode.codeUnitAt(0);
                                  // var nextSignCode = AsciiDecoder()
                                  //     .convert([(asciiOfLastSignCode + 1)])[0];
                                  // setState(() {
                                  //   signList.add(['Untitle', nextSignCode]);
                                  // });
                                  // setSignList();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddInputBoardButton(
                                        signList, setSignList, forceSetState),
                                  );
                                },
                              ),
                              additionalInputButton(
                                Icon(
                                  Icons.keyboard_hide_rounded,
                                  size: 20,
                                ),
                                () {
                                  setState(
                                    () {
                                      inputBoardVisiblity = false;
                                      openInputBoard = true;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 0, 0, 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 0.25),
                                  blurRadius: 0.5,
                                )
                              ],
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: SizedBox(
                                  // height: MediaQuery.of(context).size.width *
                                  //         1 /
                                  //         6 -
                                  //     15,
                                  height: 47,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                            1 /
                                            3 -
                                        8,
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Icon(
                                        Icons.backspace_rounded,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (currentCombination.isNotEmpty) {
                                    setState(() {
                                      currentCombination.removeLast();
                                      _controller.jumpTo(
                                          _controller.position.maxScrollExtent);
                                    });
                                  }
                                },
                                onLongPress: () {
                                  if (currentCombination.isNotEmpty) {
                                    setState(() {
                                      currentCombination = [];
                                      _controller.jumpTo(
                                          _controller.position.maxScrollExtent);
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: openInputBoard,
            child: Positioned(
              width: 60,
              height: 60,
              // In this Appbar height is fixed at 52
              bottom: (floatingY != 15)
                  ? (MediaQuery.of(context).size.height - 60 - floatingY)
                  : 15,
              right: (floatingX != 15)
                  ? (MediaQuery.of(context).size.width - 60 - floatingX)
                  : 15,
              child: Draggable(
                feedback: FloatingActionButton(
                  child: Icon(Icons.dashboard_rounded),
                  onPressed: () {},
                ),

                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(36, 14, 123, 1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 0),
                        blurRadius: 3,
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(
                        Icons.keyboard_rounded,
                        size: 28,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      onTap: () {
                        setState(() {
                          floatingX = 15;
                          floatingY = 15;
                          inputBoardVisiblity = true;
                          openInputBoard = false;
                        });
                      },
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                // onDragStarted: () {
                //   setState(() {
                //     shouldDisplayExpandedDraggable = false;
                //     floatingY -= 120;
                //   });
                // },
                onDragUpdate: (_) {
                  floatingY -= 120;
                },
                onDragEnd: (details) {
                  print('${details.offset.dx} ${details.offset.dy}');
                  setState(() {
                    floatingX = details.offset.dx;
                    floatingY = details.offset.dy;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnterCombinationWithBlinker extends StatefulWidget {
  const EnterCombinationWithBlinker({Key? key}) : super(key: key);

  @override
  _EnterCombinationWithBlinkerState createState() =>
      _EnterCombinationWithBlinkerState();
}

class _EnterCombinationWithBlinkerState
    extends State<EnterCombinationWithBlinker> {
  var blinkerStatus = true;

  startBlinker() async {
    if (mounted) {
      setState(() {
        blinkerStatus = !blinkerStatus;
      });
    }
    Future.delayed(Duration(milliseconds: 500), () {
      startBlinker();
    });
  }

  @override
  void initState() {
    super.initState();
    startBlinker();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ' |',
          style: TextStyle(
            color: blinkerStatus
                ? Color.fromRGBO(230, 0, 0, 1)
                : Colors.transparent,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const Text(
          'Enter Combination ',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

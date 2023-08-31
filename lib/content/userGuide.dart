import 'package:baseballcodebreaker/content/videoPlayer.dart';
import 'package:baseballcodebreaker/services/ad_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../globalVariables.dart';

class UserGuide extends StatefulWidget {
  final Function pageNumberSelector;

  const UserGuide(this.pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _UserGuideState createState() => _UserGuideState();
}

class _UserGuideState extends State<UserGuide> {
  var isManualExpanded = false;
  var isAdsLoaded = false;

  // Get user guide date

  var isUpdateAvailable = false;

  final FirebaseFirestore _firestore = Fire().getInstance;

  getUserGuideDate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        _firestore.collection('updateApp').get().then(
          (QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              setState(() {
                userGuideData = doc['userGuide'];
                isUserGuideDataFetched = true;
              });
            }
          },
        );
      } catch (error) {
        print('Update check Error');
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'No Internet',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                Icon(
                  Icons.wifi_off_rounded,
                  color: Color.fromRGBO(230, 0, 0, 1),
                  size: 32,
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () async {
                  await Future.delayed(Duration(milliseconds: 50), () {
                    getUserGuideDate();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Color.fromRGBO(230, 0, 0, 1),
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (userGuideData.isEmpty && isUserGuideDataFetched == false) {
      getUserGuideDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.pageNumberSelector(1);
        return false;
      },
      child: Container(
        color: Color.fromRGBO(247, 247, 247, 1),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Notes  :)',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Color.fromRGBO(230, 0, 0, 1),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: 'Accuracy ',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 17,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            height: 1.35,
                          ),
                        ),
                        TextSpan(
                          text: ' (chances of getting correct touch points) ',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 200, 1),
                            fontSize: 17,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            height: 1.35,
                          ),
                        ),
                        TextSpan(
                          text:
                              'increase with increase in number of training data.',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 17,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Have patience. Keep adding more data.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            //   decoration: BoxDecoration(
            //     color: Color.fromRGBO(255, 255, 255, 1),
            //     borderRadius: BorderRadius.circular(3),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.grey,
            //         offset: Offset(0, 0.5),
            //         blurRadius: 1,
            //       ),
            //     ],
            //   ),
            //   child: ExpansionPanelList(
            //     expansionCallback: (panelIndex, isExpanded) {
            //       setState(() {
            //         isManualExpanded = !isManualExpanded;
            //       });
            //     },
            //     expandedHeaderPadding: EdgeInsets.all(0),
            //     children: [
            //       ExpansionPanel(
            //         backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            //         canTapOnHeader: true,
            //         isExpanded: isManualExpanded,
            //         headerBuilder: (context, inOpen) {
            //           return Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Container(
            //                 color: isManualExpanded
            //                     ? Color.fromRGBO(230, 255, 230, 1)
            //                     : Colors.transparent,
            //                 width: double.infinity,
            //                 padding: EdgeInsets.all(10),
            //                 child: Text(
            //                   'How to Use ?',
            //                   style: TextStyle(
            //                     color: Color.fromRGBO(230, 0, 0, 1),
            //                     fontSize: 20,
            //                     fontFamily: 'Signika',
            //                     fontWeight: FontWeight.w600,
            //                     letterSpacing: 1.5,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //         body: Container(
            //           width: double.infinity,
            //           padding: EdgeInsets.all(10),
            //           child: Column(
            //             children: [
            //               RichText(
            //                 text: TextSpan(
            //                   children: const [
            //                     TextSpan(
            //                       text: 'Pankaj Kumar',
            //                       style: TextStyle(
            //                         color: Color.fromRGBO(255, 0, 0, 1),
            //                         fontSize: 17,
            //                         fontFamily: 'Signika',
            //                         fontWeight: FontWeight.w500,
            //                         letterSpacing: 1.5,
            //                         height: 1.35,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            (userGuideData.isEmpty && isUserGuideDataFetched == false)
                ? Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            ...userGuideData.mapIndexed(
              (index, element) => GestureDetector(
                child: LayoutBuilder(
                  builder: (context, boxconstrain) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0.5),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: (boxconstrain.maxWidth < 500)
                          ? Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://img.youtube.com/vi/${element["vid"]}/maxresdefault.jpg',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          // margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(3),
                                              topRight: Radius.circular(3),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          backgroundColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/not_found.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: Text(
                                    element['title'].toString(),
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  height: 180,
                                  width: 320,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text('Video'),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: 180,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(3),
                                        bottomRight: Radius.circular(3),
                                      ),
                                    ),
                                    child: Text(
                                      'Baseball Codebreaker - A Quick guide.',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                        color: Color.fromRGBO(36, 14, 123, 1),
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayer(
                      element['vid'],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

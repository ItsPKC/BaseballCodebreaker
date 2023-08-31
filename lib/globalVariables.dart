import 'dart:isolate';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// UserGuide Data
var userGuideData = [];
var isUserGuideDataFetched = false;

// Ads Started ---------------------------------------------------

var isInterstitialAdsLoadingAttemped = false;

// Ads Refresh timing
var bAds1 = 90;
var bAds2 = 90;
var iAds1 = 120;
var iAds2 = 120;
var iAds3 = 120;
var iAds4 = 120;
var showBanner1 = 1;
var showBanner2 = 1;
intAdsRefreshTime(adsIndex) {
  switch (adsIndex) {
    case 1:
      return iAds1;
    case 2:
      return iAds2;
    case 3:
      return iAds3;
    case 4:
      return iAds4;
  }
}

setAdsData(doc) async {
  final prefs = await SharedPreferences.getInstance();

  try {
    bAds1 = doc['bAds1'];
    await prefs.setInt('bAds1', bAds1);

    bAds2 = doc['bAds2'];
    await prefs.setInt('bAds2', bAds2);

    iAds1 = doc['iAds1'];
    await prefs.setInt('iAds1', iAds1);

    iAds2 = doc['iAds2'];
    await prefs.setInt('iAds2', iAds2);

    iAds3 = doc['iAds3'];
    await prefs.setInt('iAds3', iAds3);

    iAds4 = doc['iAds4'];
    await prefs.setInt('iAds4', iAds4);

    showBanner1 = doc['showBanner1'];
    await prefs.setInt('showBanner1', showBanner1);

    showBanner2 = doc['showBanner2'];
    await prefs.setInt('showBanner2', showBanner2);
    // print('My name is pankaj');
    // print(doc['bAds1']);
    // print(doc['bAds2']);
    // print(doc['iAds1']);
    // print(doc['iAds2']);
    // print(doc['iAds3']);
    // print(doc['iAds4']);
    // print(doc['appName']);
    // print(doc['date']);
    // print(doc['showBanner1']);
    // print(doc['showBanner2']);
  } catch (error) {
    print('Error in ads Reload time mapping');
  }
}

initialiseAdsData(prefs) {
  bAds1 = prefs.getInt('bAds1') ?? bAds1;

  bAds2 = prefs.getInt('bAds2') ?? bAds2;

  iAds1 = prefs.getInt('iAds1') ?? iAds1;

  iAds2 = prefs.getInt('iAds2') ?? iAds2;

  iAds3 = prefs.getInt('iAds3') ?? iAds3;

  iAds4 = prefs.getInt('iAds4') ?? iAds4;

  showBanner1 = prefs.getInt('showBanner1') ?? showBanner1;

  showBanner2 = prefs.getInt('showBanner2') ?? showBanner2;
}

// Ads End ------------------------------------------------------

var prefs;
obtainSharedPreferences() async {
  // Obtain shared preferences.
  prefs = await SharedPreferences.getInstance();
}

var initialSignList = [
  ['Head', 'A'],
  ['Chin', 'B'],
  ['R.Ear', 'C'],
  ['L.Ear', 'D'],
  ['R. Shoulder', 'E'],
  ['L. Shoulder', 'F'],
  ['Chest', 'G'],
  ['L. Elbow', 'H'],
  ['R. Elbow', 'I'] // Don't use comma in last to avoid error in prefs saving
];

crackNow(List<dynamic> data) async {
  print(data[1]);
  var inputCode = data[1];
  // 1 = Steal ; 0 = No-Steal
  // var inputCode = [
// //     ['aabcd', '1'],
// //     ['abcde', '1'],
// //     ['debcae', '1'],
// //     ['dabe', '0'],
// //     ['abcde', '0']

  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCDEFGHIJKLMNO', '1'],
  //   ['ABCEDACDEACDEAD', '1'],
  // ];
  var mirrorCode = [];
  var mirrorSet = [];
  var lastSet = [];
  var baseSet = [];
  var finalSet = [];

  // A reference list to hold postion as an ALTERNATIVE to number
  // to maintain accuracy beyond 10th position

  var refList = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o'
  ];

  // Start : Mirror code - List of "String of serial character equal to length of code"
  // to generate position equivalent

  //   Ex:-
  //   AFDED = abcde
  //   JEAH = abcd

  for (var u = 0; u < inputCode.length; u++) {
    var temp = '';
    for (var v = 0; v < inputCode[u][0].toString().length; v++) {
      temp += refList[v];
    }
    mirrorCode.add(temp);
    print(temp);
    temp = '';
  }

  // End : Mirror Code

  // Start - Develop all possible combo and stats

  for (var i = 0; i < mirrorCode.length; i++) {
    print('---------------------------------------------------------------$i');

    // 1 index @ per round
    // -------- Developing possible position combination (mirror - PPC) ----------------------

    for (var j = 0; j < mirrorCode[i].length; j++) {
      baseSet.add(mirrorCode[i].toString()[j]);
      mirrorSet.add(mirrorCode[i].toString()[j]);
    }
    lastSet = baseSet;
    print(baseSet);
    print(lastSet);
    var tempSet = [];

    // while (lastSet[lastSet.length - 1] != inputCode[i][0]) {
    for (var z = 0; z < mirrorCode[i].length - 1; z++) {
      for (var l = 0; l < lastSet.length; l++) {
//         print(lastSet[l]);
//         print(lastSet[l].length - 1);
        var testIndex = lastSet[l][lastSet[l].length - 1];
        print(testIndex);
        for (var b = baseSet.indexOf(testIndex); b < baseSet.length; b++) {
          if (lastSet[l][lastSet[l].length - 1] != baseSet[b]) {
            print('${lastSet[l]}${baseSet[b]}');
            // This condition is used to prevent larger String combo (4+ letter)
            // This avoid unusual workload because most of successful sign are
            // Either 2 or 3 digit combo. Yet 4 is taken for more precision.
            if ('${lastSet[l]}${baseSet[b]}'.length <= 4) {
              tempSet.add('${lastSet[l]}${baseSet[b]}');
            }
            //  -------------------------------------------------
          }
        }
        print(tempSet);
      }
      mirrorSet.addAll(tempSet);
      lastSet = tempSet;
      tempSet = [];
    }

    // -------- Particular index (mirror - PPC) developed ----------------------

    print('mirrorSet : $mirrorSet');
    print('mirrorSet Length : ${mirrorSet.length}');

    //     -------------- { mirrorSet -> finalSet } Mapping started --------------

    // Mapping : Mirror Set to equivalent code and store them in finalSet

    // Hold List of string of result
    //( This process added to remove multiple counting of same code  )

    var fractionSet = [];

    for (var f = 0; f < mirrorSet.length; f++) {
      var temp = '';
      for (var g = 0; g < mirrorSet[f].length; g++) {
        temp += inputCode[i][0]
            .toString()[int.parse('${refList.indexOf(mirrorSet[f][g])}')];
      }
      if (!fractionSet.contains(temp)) {
        fractionSet.add(temp);
      }
      temp = '';
    }

    for (var fs = 0; fs < fractionSet.length; fs++) {
      var temp = fractionSet[fs];
      var isSSPresent = false;
      chiss() {
        isSSPresent = true;
      }

      for (var r = 0; r < finalSet.length; r++) {
        if (finalSet[r][0] == temp) {
          isSSPresent = true;
          chiss();
          if (int.parse(inputCode[i][1].toString()) == 1) {
            finalSet[r][1] = int.parse(finalSet[r][1].toString()) + 1;
          } else {
            finalSet[r][2] = int.parse(finalSet[r][2].toString()) + 1;
          }
          finalSet[r][3] = int.parse(finalSet[r][1].toString()) *
              int.parse(finalSet[r][1].toString()) /
              (int.parse(finalSet[r][1].toString()) +
                  int.parse(finalSet[r][2].toString()));
        }
      }
      if (isSSPresent == false) {
        if (int.parse(inputCode[i][1].toString()) == 1) {
          finalSet.add([temp, 1, 0, 1]);
        } else {
          finalSet.add([temp, 0, 1, 0]);
        }
      }
    }

    // Clear fraction set for next round
    fractionSet = [];

    //    --------------{ mirrorSet -> finalSet } Mapping finished --------------

    // To clear mirroSet for nextRound
    mirrorSet = [];
    // To clear baseSet for nextRound
    baseSet = [];
  } // Sending loop to next index of inputCode

  // End - Developed all possible combo and stats

  print('finalSet : $finalSet');
  print('finalSet Length : ${finalSet.length}');

  //   Start - Sort list on the basis of effective value

  var term = 0;

  finalSet.sort((b, a) {
    // swapping a,b change order based on effective value
    term += 1;
    if (a[3] > b[3]) {
      return 1;
    }
    if (a[3] == b[3]) {
      if (a[0].length > b[0].length) {
        return 1;
      }

      if (a[0].length == b[0].length) {
        if (a[1] > b[1]) {
          return 1;
        }
        if (a[1] == b[1]) {
          // .compareTo is -1,0,1 for on the basis of alphabet (alternative to '>')
          if ((a[0]).compareTo(b[0]) == -1) {
            // swapping 1,-1 change order based on alphabet
            // (sign first on keyboard will get preference)
            return 1;
          }
        }
      }
    }
    return -1;
  });
  print('term : $term');

  //   End - Sort list on the basis of effective value

  print(finalSet);
  print(finalSet.length);

  var outputSet = [];
  for (var i = 0; i < min(10, finalSet.length); i++) {
    outputSet.add(finalSet[i]);
  }

  print(outputSet);
  print(outputSet.length);
  // Strength = 3 ; Positivity = 100%

  // ---------- Work for pattern prediction (show only if >50% matching)

  final SendPort _sendPort = data[0];
  return _sendPort.send(outputSet);
}

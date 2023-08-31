import 'package:baseballcodebreaker/content/editInputBoardButton.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class EditInputBoard extends StatefulWidget {
  final signList, combinationList, currentCombination;
  final Function forceSetState, setSignList;
  const EditInputBoard(this.signList, this.forceSetState, this.setSignList,
      this.combinationList, this.currentCombination,
      {Key? key})
      : super(key: key);

  @override
  _EditInputBoardState createState() => _EditInputBoardState();
}

class _EditInputBoardState extends State<EditInputBoard> {
  var tempSignList = [];
  combinedForceSetState() {
    widget.forceSetState();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tempSignList = widget.signList;
  }

  myTile(element, index) {
    return Container(
      key: Key('$index'),
      margin: EdgeInsets.fromLTRB(15, 1, 15, 1),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 1),
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: const [
                  Color.fromRGBO(0, 0, 0, 0.8),
                  Color.fromRGBO(0, 0, 0, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              element[1],
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Signika',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
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
          SizedBox(
            width: 10,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              highlightColor: Colors.amber,
              child: Container(
                height: 40,
                width: 50,
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.touch_app_rounded,
                  color: Color.fromRGBO(230, 0, 0, 1),
                ),
              ),
              onTap: () {
                // if (index != (widget.signList.length - 1)) {
                //   Future.delayed(Duration(milliseconds: 150), () {
                //     var temp = widget.signList[index + 1];
                //     // Don't use only signList, because
                //     // our mottom to edit main signList
                //     widget.signList[index + 1] = widget.signList[index];
                //     widget.signList[index] = temp;
                //     combinedForceSetState();
                //   });
                // }
              },
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Material(
            color: Color.fromRGBO(240, 240, 240, 1),
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.edit_rounded,
                ),
              ),
              onTap: () {
                Future.delayed(Duration(milliseconds: 150), () {
                  showDialog(
                    context: context,
                    builder: (context) => EditInputBoardButton(
                      element,
                      widget.signList,
                      combinedForceSetState,
                      widget.setSignList,
                      widget.combinationList,
                      widget.currentCombination,
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      proxyDecorator: (child, index, animation) => Container(
        color: Colors.amber,
        child: child,
      ),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          var temp = widget.signList[oldIndex];
          if (newIndex < oldIndex) {
            // To avoid slip
            widget.signList.removeAt(oldIndex);
            widget.signList.insert(newIndex, temp);
          } else {
            widget.signList.insert(newIndex, temp);
            widget.signList.removeAt(oldIndex);
          }
          combinedForceSetState();
        });
      },
      children: [
        ...tempSignList.mapIndexed(
          (index, element) => myTile(element, index),
        ),
      ],
    );
  }
}

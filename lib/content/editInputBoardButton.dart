import 'package:flutter/material.dart';

class EditInputBoardButton extends StatefulWidget {
  final element;
  final signList, combinationSet, currentCombination;
  final Function refresh, setSignList;

  const EditInputBoardButton(this.element, this.signList, this.refresh,
      this.setSignList, this.combinationSet, this.currentCombination,
      {Key? key})
      : super(key: key);

  @override
  _EditInputBoardButtonState createState() => _EditInputBoardButtonState();
}

class _EditInputBoardButtonState extends State<EditInputBoardButton> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   '** Don\'t DELETE or HIDE Sign while mid-process.',
          //   textAlign: TextAlign.justify,
          //   style: TextStyle(
          //     color: Color.fromRGBO(230, 0, 0, 1),
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Edit Button :)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '{ ${widget.element[0]} }',
                    textAlign: TextAlign.justify,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromRGBO(36, 14, 123, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _controller,
            onChanged: (_) {
              print(_controller.text);
            },
            decoration: InputDecoration(
              labelText: 'Sign Label Text',
              hintText: widget.element[0],
              labelStyle: TextStyle(
                fontFamily: 'Signika',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              hintStyle: TextStyle(
                fontFamily: 'Signika',
                fontSize: 16,
                // fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 40),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        OutlinedButton(
          child: Icon(
            Icons.delete,
            color: Color.fromRGBO(255, 0, 0, 1),
          ),
          onPressed: () {
            var isElementInUse = false;
            for (var i = 0; i < widget.combinationSet.length; i++) {
              for (var j = 0; j < widget.combinationSet[i][0].length; j++) {
                print(widget.combinationSet[i][0][j]);
                if (widget.combinationSet[i][0][j] == widget.element[1]) {
                  isElementInUse = true;
                  break;
                }
              }
              if (isElementInUse) {
                break;
              }
            }
            if (!isElementInUse) {
              if (widget.signList.contains(widget.element)) {
                // Clear all current list to avoid null data input
                for (var i = 0; i < widget.currentCombination.length; i++) {
                  if (widget.currentCombination[i] == widget.element[1]) {
                    widget.currentCombination.remove(widget.element[1]);
                    // Because after removing , list length decrease by 1
                    // Means next element have same index same removed one
                    // That's why below operation is performed to handle error
                    i -= 1;
                  }
                }
                // Remove that element, you want to delete
                widget.signList.remove(widget.element);
                // Set the new set of signList
                widget.setSignList();
                // Refresh page to set UI
                widget.refresh();
                Navigator.pop(context);
              }
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(children: const [
                      TextSpan(
                        text: 'Note :-',
                        style: TextStyle(
                          color: Color.fromRGBO(36, 14, 123, 1),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\n\nA sign can be removed only when it\'s not used in any of the combination(s).\n\n',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Solution :-',
                        style: TextStyle(
                          color: Color.fromRGBO(36, 14, 123, 1),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\n\nDelete all combinations containing that sign.\n\nOR, Reset codebreaker and start a new session.\n\n\n',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Can\'t delete now.\n\n',
                        style: TextStyle(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      TextSpan(
                        text:
                            'You used this sign in some of the combination(s).',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                    ]),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color.fromRGBO(36, 14, 123, 1),
            ),
          ),
          onPressed: () {
            var isSignNamePresent = false;
            for (var i = 0; i < widget.signList.length; i++) {
              if (widget.signList[i][0].toString().toUpperCase() ==
                  _controller.text.toUpperCase()) {
                isSignNamePresent = true;
              }
            }
            if (widget.signList.contains(widget.element) &&
                _controller.text.toString() != '' &&
                isSignNamePresent == false) {
              var keyIndex = widget.signList.indexOf(widget.element);
              var temp = [_controller.text, widget.element[1]];
              print(temp);
              print(widget.signList);
              widget.signList.replaceRange(keyIndex, keyIndex + 1, [temp]);
              print(widget.signList);
              widget.refresh();
              Navigator.pop(context);
            }
            if (isSignNamePresent == true) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Oh! Nooo.\n\n\n',
                        style: TextStyle(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '${_controller.text} ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'is already in used. Try another sign.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          height: 1.5,
                        ),
                      ),
                    ]),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          child: Icon(Icons.done_rounded),
        ),
      ],
    );
  }
}

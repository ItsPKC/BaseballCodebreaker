import 'dart:convert';

import 'package:flutter/material.dart';

class AddInputBoardButton extends StatefulWidget {
  final signList;
  final Function setSignList, forceSetState;
  const AddInputBoardButton(this.signList, this.setSignList, this.forceSetState,
      {Key? key})
      : super(key: key);

  @override
  _AddInputBoardButtonState createState() => _AddInputBoardButtonState();
}

class _AddInputBoardButtonState extends State<AddInputBoardButton> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Button :)',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(230, 0, 0, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
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
              labelStyle: TextStyle(
                fontFamily: 'Signika',
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
        // OutlinedButton(
        //   child: Icon(
        //     Icons.delete,
        //     color: Color.fromRGBO(255, 0, 0, 1),
        //   ),
        //   onPressed: () {},
        // ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color.fromRGBO(36, 14, 123, 1),
            ),
          ),
          child: Icon(Icons.done_rounded),
          onPressed: () {
            var isSignNamePresent = false;
            for (var i = 0; i < widget.signList.length; i++) {
              if (widget.signList[i][0].toString().toUpperCase() ==
                  _controller.text.toUpperCase()) {
                isSignNamePresent = true;
              }
            }
            if (_controller.text != '' && isSignNamePresent == false) {
              // var lastSignCode = widget.signList.last[1];
              // var asciiOfLastSignCode = lastSignCode.codeUnitAt(0);

              // Avoid providing sign to next element on the basis of last element
              // because it may cause error due to suffle

              // Instead use singList length to find the last element
              // irrespective of their position

              var asciiOfLastSignCode = 64 + widget.signList.length as int;

              var nextSignCode =
                  AsciiDecoder().convert([(asciiOfLastSignCode + 1)])[0];
              setState(() {
                widget.signList.add([_controller.text, nextSignCode]);
              });
              widget.setSignList();
              widget.forceSetState();
              Navigator.pop(context);
            } else {
              print('Empty Sign Label');
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
        ),
      ],
    );
  }
}

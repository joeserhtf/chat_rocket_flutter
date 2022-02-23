import 'dart:typed_data';

import 'package:chat_rocket_flutter/const.dart';
import 'package:chat_rocket_flutter/src/controller/chat_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:microphone/microphone.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:stop_watch_timer/stop_watch_timer.dart';

class InputBar extends StatefulWidget {
  final String roomId;

  InputBar(this.roomId);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  MicrophoneRecorder? microphoneRecorder;
  bool recording = false;
  TextEditingController _messageController = TextEditingController();
  var _formMessage = GlobalKey<FormState>();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    onChange: (value) => {},
    onChangeRawSecond: (value) => {},
    onChangeRawMinute: (value) => {},
  );

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => {});
    _stopWatchTimer.minuteTime.listen((value) => {});
    _stopWatchTimer.secondTime.listen((value) => {});
    _stopWatchTimer.records.listen((value) => {});
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(recording ? Icons.check : Icons.mic),
                onPressed: () async {
                  if (recording) {
                    _sendAudio();
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    setState(() {
                      recording = false;
                    });
                  } else {
                    _recordAudio();
                    setState(() {
                      recording = true;
                    });
                  }
                },
                color: recording ? Colors.green : iconsColor,
              ),
            ),
            //Todo checar transparencia ou white
            color: Colors.transparent,
          ),
          Visibility(
            visible: recording,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.minuteTime,
                    initialData: _stopWatchTimer.minuteTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      return Text(
                        value.toString().padLeft(2, '0') + ":",
                        style: TextStyle(fontSize: 18, fontFamily: 'Helvetica', fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.secondTime,
                    initialData: _stopWatchTimer.secondTime.value,
                    builder: (context, snap) {
                      final value = snap.data ?? 0;
                      return Text(
                        value >= 60 ? (value % 60).toString().padLeft(2, '0') : value.toString().padLeft(2, '0'),
                        style: TextStyle(fontSize: 18, fontFamily: 'Helvetica', fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: recording,
            child: Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    await microphoneRecorder?.stop();
                    microphoneRecorder?.dispose();
                    setState(() {
                      recording = false;
                    });
                  },
                  color: Colors.red,
                ),
              ),
              //Todo checar transparencia ou white
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: !recording,
            child: Material(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    FilePickerResult? pickfile = await FilePicker.platform.pickFiles(allowMultiple: true);
                    if (pickfile?.files.isNotEmpty ?? false) {
                      pickfile?.files.forEach((element) async {
                        /*var r = html.FileReader();
                        r.readAsArrayBuffer();
                        r.onLoadEnd.listen((e) {
                          var data = r.result;*/
                        RocketChatApi.uploadFile(
                          element.bytes!,
                          widget.roomId,
                          element.name,
                          element.extension!,
                        );
                        // });
                        await Future.delayed(const Duration(milliseconds: 500));
                      });
                      await Future.delayed(const Duration(seconds: 1));
                    }
                  },
                  color: iconsColor,
                ),
              ),
              //Todo checar transparencia ou white
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Container(
              child: Form(
                key: _formMessage,
                child: TextFormField(
                  onEditingComplete: () {
                    _sendMessage(_messageController.text);
                  },
                  style: TextStyle(color: textColor, fontSize: 15.0),
                  controller: _messageController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Digite uma Mensagem',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  validator: (text) {
                    if (text?.isEmpty ?? false) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: Material(
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_messageController.text);
                },
                color: iconsColor,
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[500]!, width: 0.5)), color: Colors.white),
    );
  }

  _sendMessage(text) async {
    if (_formMessage.currentState?.validate() ?? false) {
      await RocketChatApi.sendMessage(widget.roomId, text);
      _messageController.text = '';
    }
  }

  Future<void> _recordAudio() async {
    try {
      microphoneRecorder = MicrophoneRecorder()..init();
    } on Exception catch (e) {
      print(e);
    }
    await Future.delayed(Duration(milliseconds: 500));
    microphoneRecorder?.start();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  _sendAudio() async {
    try {
      await microphoneRecorder?.stop();
      final recordingUrl = microphoneRecorder?.value.recording?.url;
      var request = html.HttpRequest();
      request.responseType = "blob";
      request.open('GET', '$recordingUrl');
      request.onLoad.listen((event) {
        html.FileReader r = html.FileReader();
        r.readAsArrayBuffer(request.response.slice());
        r.onLoadEnd.listen((e) {
          Uint8List data = r.result as Uint8List; //TODO check this
          RocketChatApi.uploadAudio(data, widget.roomId, 'Audio record.mp3');
        });
      });
      request.send();
    } on Exception catch (e) {
      print(e);
    }

    microphoneRecorder?.dispose();
  }
}

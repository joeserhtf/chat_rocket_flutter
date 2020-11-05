import 'package:flutter/material.dart';
import 'package:file_picker_web/file_picker_web.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:microphone/microphone.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../const.dart';
import 'chat_api.dart';

class InputBar extends StatefulWidget {
  String roomId;

  InputBar(this.roomId);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  MicrophoneRecorder microphoneRecorder;
  TextEditingController _mensagemController = TextEditingController();
  var _formMensagem = GlobalKey<FormState>();

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    onChange: (value) => {}, //print('onChange $value'),
    onChangeRawSecond: (value) => {}, //print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => {}, //print('onChangeRawMinute $value'),
  );

  final _scrollController = ScrollController();

  bool gravando = false;

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => {} /*print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}')*/);
    _stopWatchTimer.minuteTime.listen((value) => {} /*print('minuteTime $value')*/);
    _stopWatchTimer.secondTime.listen((value) => {} /*print('secondTime $value')*/);
    _stopWatchTimer.records.listen((value) => {} /*print('records $value')*/);
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
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(gravando ? MdiIcons.check : MdiIcons.microphone),
                onPressed: () async {
                  if (gravando) {
                    _enviarAudio();
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    setState(() {
                      gravando = false;
                    });
                  } else {
                    _gravarAudio();
                    setState(() {
                      gravando = true;
                    });
                  }
                },
                color: gravando ? Colors.green : primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Visibility(
            visible: gravando,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.minuteTime,
                    initialData: _stopWatchTimer.minuteTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      return Text(
                        value.toString().padLeft(2, '0') + ":",
                        style: const TextStyle(fontSize: 18, fontFamily: 'Helvetica', fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.secondTime,
                    initialData: _stopWatchTimer.secondTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
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
            visible: gravando,
            child: Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(MdiIcons.close),
                  onPressed: () async {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    await microphoneRecorder.stop();
                    microphoneRecorder.dispose();
                    setState(() {
                      gravando = false;
                    });
                  },
                  color: Colors.red,
                ),
              ),
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: !gravando,
            child: Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(MdiIcons.paperclip),
                  onPressed: () async {
                    var pickfile = await FilePicker.getMultiFile();
                    if (pickfile.isNotEmpty) {
                      pickfile.forEach((element) async {
                        //*print(element);
                        var r = new html.FileReader();
                        r.readAsArrayBuffer(element.slice());
                        r.onLoadEnd.listen((e) {
                          var data = r.result;
                          RocketChatApi.uploadArquivo(data, widget.roomId, element.name, element.type);
                        });
                        await Future.delayed(Duration(milliseconds: 500));
                      });
                      await Future.delayed(Duration(seconds: 1));
                    }
                  },
                  color: primaryColor,
                ),
              ),
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Container(
              child: Form(
                key: _formMensagem,
                child: TextFormField(
                  onEditingComplete: () {
                    _enviarMensagem(_mensagemController.text);
                  },
                  style: TextStyle(color: primaryColor, fontSize: 15.0),
                  controller: _mensagemController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Digite uma Mensagem',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _enviarMensagem(_mensagemController.text);
                },
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[500] /*greyColor2*/, width: 0.5)), color: Colors.white),
    );
  }

  _enviarMensagem(text) async {
    if (_formMensagem.currentState.validate()) {
      await RocketChatApi.enviarMensagem(widget.roomId, text);
      _mensagemController.text = '';
    }
  }

  Future<void> _gravarAudio() async {
    try {
      microphoneRecorder = MicrophoneRecorder()..init();
    } on Exception catch (e) {
      print(e);
    }
    await Future.delayed(Duration(milliseconds: 500));
    microphoneRecorder.start();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  _enviarAudio() async {
    try {
      await microphoneRecorder.stop();
      final recordingUrl = microphoneRecorder.value.recording.url;
      var request = new html.HttpRequest();
      request.responseType = "blob";
      request.open('GET', '$recordingUrl');
      request.onLoad.listen((event) {
        var r = new html.FileReader();
        r.readAsArrayBuffer(request.response.slice());
        r.onLoadEnd.listen((e) {
          var data = r.result;
          RocketChatApi.uploadAudio(data, widget.roomId, 'Audio record.mp3');
        });
      });
      request.send();
    } on Exception catch (e) {
      print(e);
    }

    microphoneRecorder.dispose();
  }
}

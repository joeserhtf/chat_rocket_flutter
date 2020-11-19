import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_rocket_flutter/classes/class_socketRoom.dart';
import 'package:chat_rocket_flutter/components/chat_api.dart';
import 'package:chat_rocket_flutter/components/widgets.dart';
import 'package:chat_rocket_flutter/const.dart';
import 'package:flutter/material.dart';

class MiniChats extends StatefulWidget {
  List<Update> rooms;
  Function funcaoT;

  MiniChats(this.rooms, this.funcaoT);

  @override
  _MiniChatsState createState() => _MiniChatsState();
}

class _MiniChatsState extends State<MiniChats> {
  List<Widget> miniRooms = [];
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    //print('Rebuild mini');
    return Container(
      width: expandedChat ? null : widthChatBox,
      child: Stack(
        children: [
          Container(
            height: expandedChat ? 50 : 40,
            padding: EdgeInsets.only(right: 8),
            child: ListView.builder(
              controller: _controller,
              padding: EdgeInsets.only(left: 25, right: 35),
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return conversasMini(rooms[widget.rooms.length - 1 - index], rooms.length - 1 - index);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(right: 8),
              height: 40,
              width: 35,
              child: Tooltip(
                message: 'Status',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await RocketChatApi.changeStatus(!agentOnline);
                      setState(() {
                        agentOnline = !agentOnline;
                      });
                    },
                    child: Icon(
                      Icons.circle,
                      color: agentOnline ? Colors.green : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 8),
              height: 40,
              width: 35,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _controller.animateTo((_controller.position.pixels + 50),
                        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: expandedChat ? Colors.white : iconsColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  conversasMini(Update sala, int index) {
    bool ativo = selectedRoom == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoom = index;
          widget.funcaoT();
        });
        blocMensagens.add(null);
        loadRooms();
        globalRoomId = sala.sId;
      },
      child: expandedChat
          ? _conversasExpandido(sala, ativo)
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Badge(
                showBadge: !ativo && sala.lastMessage.token != null,
                badgeContent: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                shape: BadgeShape.circle,
                animationType: BadgeAnimationType.scale,
                child: Card(
                  elevation: 5,
                  margin: ativo ? EdgeInsets.only(right: 0, left: 4) : EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(ativo ? 0 : 32),
                        bottomRight: Radius.circular(ativo ? 0 : 32)),
                  ),
                  child: Container(
                    height: ativo ? 40 : 30,
                    width: ativo ? 40 : 30,
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: "",
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(),
                        padding: EdgeInsets.all(10.0),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: ativo ? 40 : 30,
                        height: ativo ? 40 : 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(ativo ? 0 : 32),
                              bottomRight: Radius.circular(ativo ? 0 : 32)),
                          color: Color((multiplicadorCor(sala.sId, sala.departmentId) * 0xFFFFFF).toInt()).withOpacity(1.0),
                        ),
                        child: Text(
                          '${sala == null ? '' : sala.fname.substring(0, 1)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  _conversasExpandido(Update sala, bool selecionado) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white, width: 0.3),
        ),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.08,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: Text(
                  allWordsCapitilize(sala.fname).split(' ')[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selecionado ? Colors.white : Colors.grey[300],
                    fontSize: selecionado ? 18 : 14,
                  ),
                ),
              ),
              selecionado
                  ? Container(
                      height: 2,
                      color: Colors.grey[400],
                      width: MediaQuery.of(context).size.width * 0.08,
                    )
                  : Container(),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 2),
              child: Badge(
                showBadge: sala.lastMessage.token != null && !selecionado,
                badgeContent: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                shape: BadgeShape.circle,
                animationType: BadgeAnimationType.scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

loadRooms() async {
  List<Update> preRooms;
  if (rocketUser != null) {
    preRooms = await RocketChatApi.getLiveRooms(rocketUser.data.userId, rocketUser.data.authToken);
    if (liveRooms == null ? true : checkLM(liveRooms, preRooms)) {
      liveRooms = preRooms;
      waitingRooms = 0;
      liveRooms.forEach((element) {
        if (element.t == 'l') waitingRooms++;
      });
      blocRooms.add(liveRooms);
    } else if (fistChat) {
      blocRooms.add(preRooms);
      fistChat = false;
    }
  }
}

checkLM(List<Update> nowLive, List<Update> newLive) {
  if (nowLive.length != newLive.length) {
    return true;
  } else {
    for (int k = 0; k < newLive.length; k++) {
      if ((nowLive[k].lastMessage.ts.date != newLive[k].lastMessage.ts.date) && newLive[k].lastMessage.u.username.contains("guest")) {
        nowLive = newLive;
        return true;
      }
    }
    return false;
  }
}

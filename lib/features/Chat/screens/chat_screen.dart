import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:smartchat/features/Chat/models/chat_messages.dart';
import 'package:smartchat/features/Registration/screens/loginScreen.dart';
import 'package:smartchat/interceptors/firebase_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../resources/all_resources.dart';
import '../../Home/widgets/all_widgets.dart';
import '../../Registration/providers/auth_provider.dart';
import '../providers/all_chatProviders.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  // void startRecord() {
  //   setState(() {
  //     isRecording = true;
  //   });
  // }
  //
  // void stopRecord() {
  //   setState(() {
  //     isRecording = false;
  //   });
  // }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    var url = 'tel://$phoneNumber';
    var uri = Uri(host: url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image, true);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  bool isSending = false;

  void onSendMessage(String content, int type, bool seen) {
    setState(() {
      isSending = true;
    });
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      Future.delayed(Duration(seconds: 1), () {
        chatProvider.sendChatMessage(
            content, type, groupChatId, currentUserId, widget.peerId, seen);
        setState(() {
          isSending = false;
        });
      });

      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
    // setState(() {
    //   isSending = false;
    // });
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isPlayingMsg = false, isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.backgroundColor,
        leadingWidth: 30,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.dimen_6),
                ),
                child: Image.network(
                  widget.peerAvatar,
                  width: Sizes.dimen_40,
                  height: Sizes.dimen_40,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext ctx, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.burgundy,
                        value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return const Icon(
                      Icons.account_circle,
                      size: 35,
                      color: ColorManager.greyColor,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '${widget.peerNickname}'.trim(),
                  style: TextStyle(
                    color: ColorManager.fontColor,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData.fallback().copyWith(
          color: ColorManager.fontColor,
        ),
        actions: [
          // Consumer(
          //   builder: (context, HomeNotifier homeNotifier, child) => IconButton(
          //     onPressed: () {
          //       homeNotifier.onJoin(context, "yahya");
          //     },
          //     icon: const Icon(Icons.video_call),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border:
                    Border.all(color: ColorManager.greyColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(Sizes.dimen_6),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ProfileProvider profileProvider;
                  profileProvider = context.read<ProfileProvider>();
                  String callPhoneNumber = profileProvider
                          .getPrefs(FirestoreConstants.phoneNumber) ??
                      "";
                  _callPhoneNumber(callPhoneNumber);
                },
                icon: const Icon(
                  Icons.phone,
                  color: ColorManager.fontColor,
                  size: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border:
                    Border.all(color: ColorManager.greyColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(Sizes.dimen_6),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ProfileProvider profileProvider;
                  profileProvider = context.read<ProfileProvider>();
                  String callPhoneNumber = profileProvider
                          .getPrefs(FirestoreConstants.phoneNumber) ??
                      "";
                  _callPhoneNumber(callPhoneNumber);
                },
                icon: const Icon(
                  Icons.videocam_rounded,
                  color: ColorManager.fontColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
          child: Column(
            children: [
              buildListMessage(),
              SizedBox(
                height: 10,
              ),
              isSending
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : SizedBox.shrink(),
              buildMessageInput(),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _loadFile(String url) async {
    final bytes = await readBytes(Uri(host: url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;
        isPlayingMsg = true;
        print(isPlayingMsg);
      });
      await play();
      setState(() {
        isPlayingMsg = false;
        print(isPlayingMsg);
      });
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath!, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  String? recordFilePath;

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath!,
        isLocal: true,
      );
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          FirestoreConstants.idFrom: currentUserId,
          FirestoreConstants.idTo: widget.peerId,
          FirestoreConstants.timestamp:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.content: audioMsg,
          FirestoreConstants.type: 3,
        });
      }).then((value) {
        setState(() {
          isSending = false;
        });
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Hello");
    }
  }

  uploadAudio() {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    UploadTask uploadTask = ref.putFile(File(recordFilePath!));
    uploadTask.then(
      (value) async {
        print('##############done#########');
        var audioURL = await value.ref.getDownloadURL();
        String strVal = audioURL.toString();
        await sendAudioMsg(strVal);
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          isRecording
              ? Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Recording ...",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Flexible(
                  child: Container(
                    margin: const EdgeInsets.all(Sizes.dimen_10),
                    height: Sizes.dimen_50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: Sizes.dimen_4,
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: getImage,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: Sizes.dimen_20,
                          ),
                          color: ColorManager.fontColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusNode,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textInputAction: TextInputAction.search,
                            controller: textEditingController,
                            onFieldSubmitted: (value) {
                              onSendMessage(textEditingController.text,
                                  MessageType.text, false);
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Type your message',
                              hintStyle: TextStyle(
                                  color: ColorManager.greyColor, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.backgroundColor,
                      borderRadius: BorderRadius.circular(
                        Sizes.dimen_8,
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: isRecording ? Colors.white : Colors.black12,
                  spreadRadius: 4)
            ], color: ColorManager.spaceCadet, shape: BoxShape.circle),
            child: GestureDetector(
              onLongPress: () {
                startRecord();
                setState(() {
                  isRecording = true;
                });
              },
              onLongPressEnd: (details) {
                stopRecord();
                setState(() {
                  isRecording = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: Sizes.dimen_4),
            decoration: BoxDecoration(
              color: ColorManager.myMessagesColor,
              borderRadius: BorderRadius.circular(Sizes.dimen_10),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(
                    textEditingController.text, MessageType.text, true);
              },
              icon: const Icon(
                Icons.send_rounded,
                size: 18,
              ),
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.audio
                    ? VoiceMessage(
                        contactFgColor: ColorManager.myMessagesColor,
                        meBgColor: ColorManager.backgroundColor,
                        audioSrc: '${chatMessages.content}',
                        played: true,
                        me: false,
                        noiseCount: 1,
                        onPlay: () {
                          _loadFile('${chatMessages.content}');
                        }, // Do something when voice played.
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? Row(
                        children: [
                          messageBubble(
                            chatContent: chatMessages.content,
                            color: ColorManager.myMessagesColor,
                            textColor: ColorManager.white,
                            margin:
                                const EdgeInsets.only(right: Sizes.dimen_10),
                          ),
                        ],
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(
                                right: Sizes.dimen_10, top: Sizes.dimen_10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(Sizes.dimen_6),
                        ),
                        child: Image.network(
                          widget.userAvatar,
                          width: Sizes.dimen_40,
                          height: Sizes.dimen_40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.burgundy,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: ColorManager.greyColor,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 40,
                      ),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: const EdgeInsets.only(
                        right: Sizes.dimen_50,
                        top: Sizes.dimen_6,
                        bottom: Sizes.dimen_8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: ColorManager.lightGrey,
                          fontSize: Sizes.dimen_12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)

                    // left side (received message) Peer User
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.dimen_6),
                        ),
                        child: Image.network(
                          widget.peerAvatar,
                          width: Sizes.dimen_40,
                          height: Sizes.dimen_40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.burgundy,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: ColorManager.greyColor,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 40,
                      ),
                chatMessages.type == MessageType.audio
                    ? VoiceMessage(
                        contactFgColor: ColorManager.peerMessagesColor,
                        meBgColor: ColorManager.backgroundColor,
                        audioSrc: '${chatMessages.content}',
                        played: true,
                        me: true,
                        noiseCount: 1,
                        onPlay: () {
                          _loadFile('${chatMessages.content}');
                        }, // Do something when voice played.
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        isMe: false,
                        color: ColorManager.peerMessagesColor,
                        textColor: ColorManager.fontColor,
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: Sizes.dimen_10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(
                                left: Sizes.dimen_10, top: Sizes.dimen_10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(
                        left: Sizes.dimen_50,
                        top: Sizes.dimen_6,
                        bottom: Sizes.dimen_8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: ColorManager.lightGrey,
                          fontSize: Sizes.dimen_12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return buildItem(index, snapshot.data?.docs[index]);
                          } else {
                            return Center(
                              child: SizedBox(
                                height: 36,
                                width: 36,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                            );
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.burgundy,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: ColorManager.burgundy,
              ),
            ),
    );
  }
}

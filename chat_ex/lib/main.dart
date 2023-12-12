import 'dart:convert';
import 'dart:io';
import 'package:chat_ui/chat_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel> _messages = [];

  final ValueNotifier<List<MessageModel>> _messNotifier =
      ValueNotifier<List<MessageModel>>([]);

  bool isLoadMore = false;
  final _user = const UserModel(
    isBase64UrlOfAvatar: false,
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'Danibekk',
    lastName: 'Sultanovv',
  );
  final _userRes = const UserModel(
    isBase64UrlOfAvatar: false,
    id: '82091008-a484-4a89-ae75-a22bf8d6f3a21',
    firstName: 'John',
    lastSeen: 2,
    role: Role.admin,
    imageUrl:
        'https://yt3.googleusercontent.com/-CFTJHU7fEWb7BYEb6Jh9gm1EpetvVGQqtof0Rbh-VQRIznYYKJxCaqv_9HeBcmJmIsp2vOO9JU=s900-c-k-c0x00ffffff-no-rj',
  );

  @override
  void initState() {
    super.initState();
  }

  void _addMessage(MessageModel message) {
    _messNotifier.value = List.of(_messNotifier.value)..insert(0, message);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = FileMessageModel(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueKey().toString(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = ImageMessageModel(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: UniqueKey().toString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
        showStatus: true,
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, MessageModel message) async {
    // if (message is FileMessageModel) {
    //   var localPath = message.uri;

    //   if (message.uri.startsWith('http')) {
    //     try {
    //       final index =
    //           _messages.indexWhere((element) => element.id == message.id);
    //       final updatedMessage =
    //           (_messages[index] as FileMessageModel).copyWith(
    //         isLoading: true,
    //       );

    //       setState(() {
    //         _messages[index] = updatedMessage;
    //       });

    //       final client = http.Client();
    //       final request = await client.get(Uri.parse(message.uri));
    //       final bytes = request.bodyBytes;
    //       final documentsDir = (await getApplicationDocumentsDirectory()).path;
    //       localPath = '$documentsDir/${message.name}';

    //       if (!File(localPath).existsSync()) {
    //         final file = File(localPath);
    //         await file.writeAsBytes(bytes);
    //       }
    //     } finally {
    //       final index =
    //           _messages.indexWhere((element) => element.id == message.id);
    //       final updatedMessage =
    //           (_messages[index] as FileMessageModel).copyWith(
    //         isLoading: null,
    //       );

    //       setState(() {
    //         _messages[index] = updatedMessage;
    //       });
    //     }
    //   }

    //   await OpenFilex.open(localPath);
    // }
  }

  void _handlePreviewDataFetched(
    TextMessageModel message,
    PreviewDataModel previewData,
  ) {
    final index =
        _messNotifier.value.indexWhere((element) => element.id == message.id);
    if (index == -1) return;
    final updatedMessage =
        (_messNotifier.value[index] as TextMessageModel).copyWith(
      previewData: previewData,
    );

    // setState(() {
    //   _messages[index] = updatedMessage;
    // });
    _messNotifier.value[index] = updatedMessage;
  }

  void _handleSendPressed(PartialText message) {
    final textMessage = TextMessageModel(
      author: _user,
      isOwner: false,
      status: Status.sent,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: message.text,
      showStatus: true,
    );

    // print(' - - - - -   Before ${textMessage.isOwner} - - - - --  ');

    _addMessage(textMessage);
  }

  void _handleSendEmojiPressed(String message) {
    final textMessage = TextMessageModel(
      author: _userRes,
      status: Status.sending,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: message,
      showStatus: true,
      isOwner: false,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ValueListenableBuilder<List<MessageModel>>(
            valueListenable: _messNotifier,
            builder: (context, list, __) {
              return Chat(
                emptyStateText: 'Salamm',
                messages: list,
                onEmptyPressed: (emj) => _handleSendEmojiPressed(emj),
                onEmojiPressed: (emj) => _handleSendEmojiPressed(emj),
                // onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                isLastPage: false,
                onEndReached: () async {},
                customDateHeaderText: (p0) {
                  final cDate = '${p0.day} october ${p0.year} y.';
                  return cDate;
                },
                user: _userRes,
              );
            }),
      );
}

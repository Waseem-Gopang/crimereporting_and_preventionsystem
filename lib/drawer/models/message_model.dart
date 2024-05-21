import 'info_model.dart';

class SosMessage {
  String messageID;
  String userID;
  String content;
  bool messageContact;
  List<Info> infoList;

  SosMessage(this.messageID, this.userID, this.content, this.messageContact,
      this.infoList);
}

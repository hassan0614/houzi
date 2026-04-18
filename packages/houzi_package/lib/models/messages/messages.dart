class Messages {
  bool? success;
  String? senderStatus;
  String? receiverStatus;
  List<MessageItem>? messagesList;

  Messages({
    this.success,
    this.senderStatus,
    this.receiverStatus,
    this.messagesList,
  });
}

class MessageItem {
  String? id;
  String? createdBy;
  String? threadId;
  String? message;
  String? attachments;
  String? receiverDelete;
  String? senderDelete;
  String? time;
  DateTime? timeInDateTimeFormat;
  String? timeInTimeAgoFormat;
  String? messageTime;
  String? messageDate;

  MessageItem({
    this.id,
    this.createdBy,
    this.threadId,
    this.message,
    this.attachments,
    this.receiverDelete,
    this.senderDelete,
    this.time,
    this.timeInDateTimeFormat,
    this.timeInTimeAgoFormat,
    this.messageTime,
    this.messageDate,
  });
}

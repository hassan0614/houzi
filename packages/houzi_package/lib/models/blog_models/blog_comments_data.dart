class BlogCommentsData {
  bool? success;
  int? count;
  List<BlogComment>? commentsList;

  BlogCommentsData({
    this.success,
    this.count,
    this.commentsList,
  });
}

class BlogComment {
  String? commentId;
  String? commentPostId;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorUrl;
  String? commentAuthorIp;
  DateTime? commentDate;
  DateTime? commentDateGmt;
  String? commentDateFormatted;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? commentAuthorAvatar;

  BlogComment({
    this.commentId,
    this.commentPostId,
    this.commentAuthor,
    this.commentAuthorEmail,
    this.commentAuthorUrl,
    this.commentAuthorIp,
    this.commentDate,
    this.commentDateGmt,
    this.commentDateFormatted,
    this.commentContent,
    this.commentKarma,
    this.commentApproved,
    this.commentAgent,
    this.commentType,
    this.commentParent,
    this.userId,
    this.commentAuthorAvatar,
  });
}

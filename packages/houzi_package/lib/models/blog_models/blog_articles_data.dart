class BlogArticlesData {
    bool? success;
    int? count;
    List<BlogArticle>? articlesList;

    BlogArticlesData({
        this.success,
        this.count,
        this.articlesList,
    });
}

class BlogArticle {
    int? id;
    String? postAuthor;
    DateTime? postDate;
    DateTime? postDateGmt;
    String? postDateFormatted;
    String? postContent;
    String? postTitle;
    String? postExcerpt;
    String? postStatus;
    String? commentStatus;
    String? pingStatus;
    String? postPassword;
    String? postName;
    String? toPing;
    String? pinged;
    DateTime? postModified;
    DateTime? postModifiedGmt;
    String? postModifiedFormatted;
    String? postContentFiltered;
    int? postParent;
    String? guid;
    int? menuOrder;
    String? postType;
    String? postMimeType;
    CommentCount? commentCount;
    String? filter;
    String? thumbnail;
    String? photo;
    BlogMeta? meta;
    BlogAuthor? author;
    List<BlogArticleCategory>? categories;
    List<BlogArticleCategory>? tags;

    BlogArticle({
        this.id,
        this.postAuthor,
        this.postDate,
        this.postDateGmt,
        this.postDateFormatted,
        this.postContent,
        this.postTitle,
        this.postExcerpt,
        this.postStatus,
        this.commentStatus,
        this.pingStatus,
        this.postPassword,
        this.postName,
        this.toPing,
        this.pinged,
        this.postModified,
        this.postModifiedGmt,
        this.postModifiedFormatted,
        this.postContentFiltered,
        this.postParent,
        this.guid,
        this.menuOrder,
        this.postType,
        this.postMimeType,
        this.commentCount,
        this.filter,
        this.thumbnail,
        this.photo,
        this.meta,
        this.author,
        this.categories,
        this.tags,
    });
}

class BlogAuthor {
    String? id;
    String? name;
    String? avatar;

    BlogAuthor({
        this.id,
        this.name,
        this.avatar,
    });
}

class BlogArticleCategory {
    int? termId;
    String? name;
    String? slug;
    int? termGroup;
    int? termTaxonomyId;
    String? taxonomy;
    String? description;
    int? parent;
    int? count;
    String? filter;

    BlogArticleCategory({
        this.termId,
        this.name,
        this.slug,
        this.termGroup,
        this.termTaxonomyId,
        this.taxonomy,
        this.description,
        this.parent,
        this.count,
        this.filter,
    });
}

class CommentCount {
    int? approved;
    int? awaitingModeration;
    int? spam;
    int? trash;
    int? postTrashed;
    int? all;
    int? totalComments;

    CommentCount({
        this.approved,
        this.awaitingModeration,
        this.spam,
        this.trash,
        this.postTrashed,
        this.all,
        this.totalComments,
    });
}

class BlogMeta {
    List<String>? dpOriginal;
    List<String>? thumbnailId;
    List<String>? wxrImportHasAttachmentRefs;
    List<String>? editLock;
    List<String>? editLast;
    List<String>? onesignalMetaBoxPresent;
    List<String>? onesignalSendNotification;
    List<String>? onesignalModifyTitleAndContent;
    List<dynamic>? onesignalNotificationCustomHeading;
    List<dynamic>? onesignalNotificationCustomContent;
    List<String>? responseBody;
    List<String>? status;
    List<String>? recipients;
    List<String>? wpPageTemplate;
    List<String>? rsPageBgColor;
    List<String>? pingme;
    List<String>? encloseme;

    BlogMeta({
        this.dpOriginal,
        this.thumbnailId,
        this.wxrImportHasAttachmentRefs,
        this.editLock,
        this.editLast,
        this.onesignalMetaBoxPresent,
        this.onesignalSendNotification,
        this.onesignalModifyTitleAndContent,
        this.onesignalNotificationCustomHeading,
        this.onesignalNotificationCustomContent,
        this.responseBody,
        this.status,
        this.recipients,
        this.wpPageTemplate,
        this.rsPageBgColor,
        this.pingme,
        this.encloseme,
    });
}
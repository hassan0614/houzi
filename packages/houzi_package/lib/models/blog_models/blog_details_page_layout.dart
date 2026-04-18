class BlogDetailsPageLayout {
  List<BlogDetailPageLayout>? blogDetailPageLayout;

  BlogDetailsPageLayout({
    this.blogDetailPageLayout,
  });
}

class BlogDetailPageLayout {
  String? widgetType;
  String? widgetTitle;
  bool? widgetEnable;
  String? widgetViewType;

  BlogDetailPageLayout({
    this.widgetType,
    this.widgetTitle,
    this.widgetEnable,
    this.widgetViewType,
  });
}
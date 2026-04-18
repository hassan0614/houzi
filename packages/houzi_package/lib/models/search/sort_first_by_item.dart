class SortFirstBy {
  List<SortFirstByItem>? sortFirstBy;

  SortFirstBy({
    this.sortFirstBy,
  });
}

class SortFirstByItem {
  String? sectionType;
  String? title;
  String? defaultValue;
  String? icon;
  String? term;
  String? subTerm;

  SortFirstByItem({
    this.sectionType,
    this.title,
    this.defaultValue,
    this.icon,
    this.term,
    this.subTerm,
  });
}
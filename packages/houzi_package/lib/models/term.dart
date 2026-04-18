import 'dart:convert';

class Term {
  int? id;
  int? parent;
  int? totalPropertiesCount;
  String? name;
  String? slug;
  String? thumbnail;
  String? fullImage;
  String? taxonomy;
  String? parentTerm;

  Term({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.thumbnail,
    this.taxonomy,
    this.fullImage,
    this.totalPropertiesCount,
    this.parentTerm,
  });

  @override
  bool operator == (Object other){
    return other is Term && slug == other.slug;
  }
}

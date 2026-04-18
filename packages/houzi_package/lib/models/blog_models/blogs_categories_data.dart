class BlogCategoriesData {
  bool? success;
  List<BlogCategory>? categoriesList;

  BlogCategoriesData({
    this.success,
    this.categoriesList,
  });
}

class BlogCategory {
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
  int? catId;
  int? categoryCount;
  String? categoryDescription;
  String? catName;
  String? categoryNicename;
  int? categoryParent;

  BlogCategory({
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
    this.catId,
    this.categoryCount,
    this.categoryDescription,
    this.catName,
    this.categoryNicename,
    this.categoryParent,
  });
}

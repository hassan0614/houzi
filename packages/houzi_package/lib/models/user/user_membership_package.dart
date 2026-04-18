class UserMembershipPackage {
  bool success;
  String? remainingListings;
  String? packFeaturedRemainingListings;
  String? packageId;
  String? packagesPageLink;
  String? packTitle;
  String? packListings;
  dynamic packUnlimitedListings;
  String? packFeaturedListings;
  String? packBillingPeriod;
  String? packBillingFrequency;
  int? packDate;
  String? expiredDate;

  UserMembershipPackage({
    required this.success,
    required this.remainingListings,
    required this.packFeaturedRemainingListings,
    required this.packageId,
    required this.packagesPageLink,
    required this.packTitle,
    required this.packListings,
    this.packUnlimitedListings,
    required this.packFeaturedListings,
    required this.packBillingPeriod,
    required this.packBillingFrequency,
    required this.packDate,
    required this.expiredDate,
  });
}

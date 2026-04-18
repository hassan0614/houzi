class UserPaymentStatus {
  String? enablePaidSubmission;
  String? remainingListings;
  String? featuredRemainingListings;
  String? paymentPage;
  bool? userHasMembership;
  bool? userHadFreePackage;

  UserPaymentStatus({
    this.enablePaidSubmission,
    this.remainingListings,
    this.featuredRemainingListings,
    this.paymentPage,
    this.userHasMembership,
    this.userHadFreePackage,
  });
}

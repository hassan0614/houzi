import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class Agent {
  int? id;
  String? slug;
  String? type;
  String? title;
  String? content;
  String? totalRating;
  String? thumbnail;
  String? agentPosition;
  String? agentCompany;
  String? agentMobileNumber;
  String? agentOfficeNumber;
  String? agentFaxNumber;
  String? email;
  String? agentAddress;
  String? agentTaxNumber;
  String? agentLicenseNumber;
  String? agentServiceArea;
  String? agentSpecialties;
  List<String>? agentAgencies;
  String? agentLink;
  String? agentWhatsappNumber;
  String? agentPhoneNumber;
  String? agentId;
  String? agentUserName;
  String? userAgentId;
  String? agentFirstName;
  String? agentLastName;
  String? telegram;
  String? lineApp;
  bool hide = false;
  bool agentVerification = false;

  Agent({
    this.id,
    this.slug,
    this.type,
    this.title,
    this.content,
    this.totalRating,
    this.thumbnail,
    this.agentPosition,
    this.agentCompany,
    this.agentMobileNumber,
    this.agentOfficeNumber,
    this.agentFaxNumber,
    this.email,
    this.agentAddress,
    this.agentTaxNumber,
    this.agentLicenseNumber,
    this.agentAgencies,
    this.agentServiceArea,
    this.agentSpecialties,
    this.agentLink,
    this.agentWhatsappNumber,
    this.agentPhoneNumber,
    this.agentId,
    this.agentUserName,
    this.userAgentId,
    this.agentFirstName,
    this.agentLastName,
    this.telegram,
    this.lineApp,
    this.hide = false,
    this.agentVerification = false,
  });

  String? compiledDescription;
  String getDescription() {
    if (compiledDescription != null) return compiledDescription!;
    compiledDescription = _compileDescription();
    return compiledDescription!;
  }
  String _compileDescription() {
    // Check if content is valid and already greater than 20
    if (content != null && content!.length > 50) {
      return UtilityMethods.stripHtmlIfNeeded(content!).replaceAll("\n", " ");
    }

    // Initialize an empty content if null
    String description = UtilityMethods.stripHtmlIfNeeded(content!);
    if (description.isNotEmpty && !description.endsWith(".")) description = "$description.";
    int _countNewlines(String text) {
      return '\n'.allMatches(text).length;
    }
    // Helper function to append and check for three newline characters
    bool appendIfValid(String? field) {
      if (field != null && field.isNotEmpty) {
        description = description.isEmpty ? field : "$description\n$field";
        return _countNewlines(description) >= 2; // Check if length exceeds 20 after appending
      }
      return false;
    }

    // Append fields in the specified order
    if (appendIfValid(agentAddress)) return description.replaceAll("\n", " ");
    if (appendIfValid(agentMobileNumber)) return description.replaceAll("\n", " ");
    if (appendIfValid(email)) return description.replaceAll("\n", " ");
    if (appendIfValid(agentOfficeNumber)) return description.replaceAll("\n", " ");
    if (appendIfValid(agentPhoneNumber)) return description.replaceAll("\n", " ");

    return description; // Return final content
  }
}

class Agency {
  int? id;
  String? slug;
  String? type;
  String? title;
  String? content;
  String? thumbnail;
  String? agencyFaxNumber;
  String? agencyLicenseNumber;
  String? agencyPhoneNumber;
  String? agencyMobileNumber;
  String? email;
  String? agencyAddress;
  String? agencyMapAddress;
  String? agencyLocation;
  String? agencyTaxNumber;
  String? agencyLink;
  String? agencyWhatsappNumber;
  String? totalRating;
  String? telegram;
  String? lineApp;
  bool hide = false;
  bool agencyVerification = false;

  Agency({
    this.id,
    this.slug,
    this.type,
    this.title,
    this.content,
    this.thumbnail,
    this.agencyFaxNumber,
    this.agencyLicenseNumber,
    this.agencyPhoneNumber,
    this.agencyMobileNumber,
    this.email,
    this.agencyAddress,
    this.agencyMapAddress,
    this.agencyLocation,
    this.agencyTaxNumber,
    this.agencyLink,
    this.agencyWhatsappNumber,
    this.totalRating,
    this.telegram,
    this.lineApp,
    this.hide = false,
    this.agencyVerification = false,
  });
  String? compiledDescription;
  String getDescription() {
    if (compiledDescription != null) return compiledDescription!;
    compiledDescription = _compileDescription();
    return compiledDescription!;
  }
  String _compileDescription() {
    // Check if content is valid and already greater than 20
    if (content != null && content!.length > 50) {
      return UtilityMethods.stripHtmlIfNeeded(content!).replaceAll("\n", " ");
    }

    // Initialize an empty content if null
    String description = UtilityMethods.stripHtmlIfNeeded(content!);
    if (description.isNotEmpty && !description.endsWith(".")) description = "$description.";
    int _countNewlines(String text) {
      return '\n'.allMatches(text).length;
    }
    // Helper function to append and check for three newline characters
    bool appendIfValid(String? field) {
      if (field != null && field.isNotEmpty) {
        description = description.isEmpty ? field : "$description\n$field";
        return _countNewlines(description) >= 2; // Check if length exceeds 20 after appending
      }
      return false;
    }

    // Append fields in the specified order
    if (appendIfValid(agencyAddress)) return description.replaceAll("\n", " ");
    if (appendIfValid(agencyMobileNumber)) return description.replaceAll("\n", " ");
    if (appendIfValid(email)) return description.replaceAll("\n", " ");
    if (appendIfValid(agencyPhoneNumber)) return description.replaceAll("\n", " ");

    return description; // Return final content
  }
}

class Author {
  int? id;
  bool? isSingle;
  bool? isVerified;
  String? data;
  String? email;
  String? name;
  String? phone;
  String? phoneCall;
  String? mobile;
  String? mobileCall;
  String? whatsApp;
  String? whatsAppCall;
  String? picture;
  String? link;
  String? type;
  String? telegram;
  String? lineApp;

  Author({
    this.id,
    this.isSingle,
    this.isVerified,
    this.data,
    this.email,
    this.name,
    this.phone,
    this.phoneCall,
    this.mobile,
    this.mobileCall,
    this.whatsApp,
    this.whatsAppCall,
    this.picture,
    this.link,
    this.type,
    this.telegram,
    this.lineApp,
  });
}
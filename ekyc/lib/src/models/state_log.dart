// To parse this JSON data, do
//
//     final kycStateLog = kycStateLogFromJson(jsonString);

import 'dart:convert';

KycStateLogResponse kycStateLogFromJson(String str) =>
    KycStateLogResponse.fromJson(json.decode(str));

String kycStateLogToJson(KycStateLogResponse data) =>
    json.encode(data.toJson());

class KycStateLogResponse {
  KycStateLogResponse({
    this.status,
    this.data,
  });

  bool? status;
  KycStateLog? data;

  factory KycStateLogResponse.fromJson(Map<String, dynamic> json) =>
      KycStateLogResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : json['data'] == 'no record found'
                ? KycStateLog.fromJson({})
                : KycStateLog.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class KycStateLog {
  KycStateLog(
      {this.user,
      this.title,
      this.firstName,
      this.lastName,
      this.dob,
      this.nationality,
      this.intendedUseOfAccount,
      this.mobileNumber,
      this.phoneNumber,
      this.gender,
      this.cardIssueDate,
      this.cardExpiryDate,
      this.periodOfStay,
      this.postalCode,
      this.prefecture,
      this.city,
      this.street,
      this.buildingName,
      this.annualIncome,
      this.homeContactNumber,
      this.emergencyNumber,
      this.sourceOfIncome,
      this.taxReturn,
      this.auditReport,
      this.state,
      this.profileImage,
      this.tiltedImage,
      this.frontImage,
      this.backImage,
      this.kycType,
      this.cardNumber,
      this.blinkImage});

  int? user;
  String? title;
  String? firstName;
  String? lastName;
  String? dob;
  String? nationality;
  String? intendedUseOfAccount;
  String? mobileNumber;
  String? phoneNumber;
  String? gender;
  String? cardIssueDate;
  String? cardExpiryDate;
  String? periodOfStay;
  String? postalCode;
  String? prefecture;
  String? city;
  String? street;
  String? buildingName;
  String? annualIncome;
  String? homeContactNumber;
  String? emergencyNumber;
  String? sourceOfIncome;
  String? taxReturn;
  String? auditReport;
  String? state;
  String? profileImage;
  String? tiltedImage;
  String? frontImage;
  String? backImage;
  String? kycType;
  String? cardNumber;
  String? blinkImage;

  KycStateLog copyWith({
    int? user,
    String? title,
    String? firstName,
    dynamic lastName,
    dynamic dob,
    dynamic nationality,
    dynamic intendedUseOfAccount,
    dynamic mobileNumber,
    dynamic phoneNumber,
    dynamic gender,
    dynamic cardIssueDate,
    dynamic cardExpiryDate,
    dynamic periodOfStay,
    dynamic postalCode,
    dynamic prefecture,
    dynamic city,
    dynamic street,
    dynamic buildingName,
    dynamic annualIncome,
    dynamic homeContactNumber,
    dynamic emergencyNumber,
    dynamic sourceOfIncome,
    dynamic taxReturn,
    dynamic auditReport,
    String? state,
    String? profileImage,
    dynamic tiltedImage,
    dynamic frontImage,
    dynamic backImage,
    String? kycType,
    String? cardNumber,
  }) =>
      KycStateLog(
        user: user ?? this.user,
        title: title ?? this.title,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        nationality: nationality ?? this.nationality,
        intendedUseOfAccount: intendedUseOfAccount ?? this.intendedUseOfAccount,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        gender: gender ?? this.gender,
        cardIssueDate: cardIssueDate ?? this.cardIssueDate,
        cardExpiryDate: cardExpiryDate ?? this.cardExpiryDate,
        periodOfStay: periodOfStay ?? this.periodOfStay,
        postalCode: postalCode ?? this.postalCode,
        prefecture: prefecture ?? this.prefecture,
        city: city ?? this.city,
        street: street ?? this.street,
        buildingName: buildingName ?? this.buildingName,
        annualIncome: annualIncome ?? this.annualIncome,
        homeContactNumber: homeContactNumber ?? this.homeContactNumber,
        emergencyNumber: emergencyNumber ?? this.emergencyNumber,
        sourceOfIncome: sourceOfIncome ?? this.sourceOfIncome,
        taxReturn: taxReturn ?? this.taxReturn,
        auditReport: auditReport ?? this.auditReport,
        state: state ?? this.state,
        profileImage: profileImage ?? this.profileImage,
        tiltedImage: tiltedImage ?? this.tiltedImage,
        frontImage: frontImage ?? this.frontImage,
        backImage: backImage ?? this.backImage,
        kycType: kycType ?? this.kycType,
        cardNumber: cardNumber ?? this.cardNumber,
      );

  factory KycStateLog.fromJson(Map<String, dynamic> json) => KycStateLog(
      // user: json["user"],
      title: json["title"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      dob: json["dob"],
      nationality: json["nationality"],
      intendedUseOfAccount: json["intended_use_of_account"],
      mobileNumber: json["mobile_number"],
      phoneNumber: json["phone_number"],
      gender: json["gender"],
      cardIssueDate: json["card_issue_date"],
      cardExpiryDate: json["card_expiry_date"],
      periodOfStay: json["period_of_stay"],
      postalCode: json["postal_code"],
      prefecture: json["prefecture"],
      city: json["city"],
      street: json["street"],
      buildingName: json["building_name"],
      annualIncome: json["annual_income"],
      homeContactNumber: json["home_contact_number"],
      emergencyNumber: json["emergency_number"],
      // sourceOfIncome: json["source_of_income"],
      // taxReturn: json["tax_return"],
      // auditReport: json["audit_report"],
      state: json["state"],
      profileImage: json["profile_image"],
      tiltedImage: json["tilted_image"],
      frontImage: json["front_image"],
      backImage: json["back_image"],
      kycType: json["kyc_type"].toString(),
      cardNumber: json["card_number"],
      blinkImage: json['blink_image']);

  Map<String, dynamic> toJson() => {
        // "user": user,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "dob": dob,
        "nationality": nationality,
        "intended_use_of_account": intendedUseOfAccount,
        "mobile_number": mobileNumber,
        "phone_number": phoneNumber,
        "gender": gender,
        "card_issue_date": cardIssueDate,
        "card_expiry_date": cardExpiryDate,
        "period_of_stay": periodOfStay,
        "postal_code": postalCode,
        "prefecture": prefecture,
        "city": city,
        "street": street,
        "building_name": buildingName,
        // "annual_income": annualIncome,
        // "home_contact_number": homeContactNumber,
        // "emergency_number": emergencyNumber,
        // "source_of_income": sourceOfIncome,
        // "tax_return": taxReturn,
        // "audit_report": auditReport,
        "state": state,
        // "profile_image": profileImage,
        // "tilted_image": tiltedImage,
        // "front_image": frontImage,
        // "back_image": backImage,
        // "kyc_type": kycType,
        // "card_number": cardNumber,
        // "blink_image": blinkImage
      };
}

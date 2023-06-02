// To parse this JSON data, do
//
//     final documentUpload = documentUploadFromJson(jsonString);

import 'dart:convert';

DocumentUpload documentUploadFromJson(String str) =>
    DocumentUpload.fromJson(json.decode(str));

String documentUploadToJson(DocumentUpload data) => json.encode(data.toJson());

class DocumentUpload {
  DocumentUpload({
    this.profileImage,
    this.tiltedImage,
    this.frontImage,
    this.backImage,
    this.cardNumber,
    this.kycType,
    this.blinkImage,
  });

  String? profileImage;
  String? tiltedImage;
  String? frontImage;
  String? backImage;
  String? cardNumber;
  String? kycType;
  String? blinkImage;

  DocumentUpload copyWith({
    String? profileImage,
    String? tiltedImage,
    String? frontImage,
    String? backImage,
    String? cardNumber,
    String? kycType,
    String? blinkImage,
  }) =>
      DocumentUpload(
        profileImage: profileImage ?? this.profileImage,
        tiltedImage: tiltedImage ?? this.tiltedImage,
        frontImage: frontImage ?? this.frontImage,
        backImage: backImage ?? this.backImage,
        cardNumber: cardNumber ?? this.cardNumber,
        kycType: kycType ?? this.kycType,
        blinkImage: blinkImage ?? this.blinkImage,
      );

  factory DocumentUpload.fromJson(Map<String, dynamic> json) => DocumentUpload(
        profileImage: json["profile_image"],
        tiltedImage: json["tilted_image"],
        frontImage: json["front_image"],
        backImage: json["back_image"],
        cardNumber: json["card_number"],
        kycType: json["kyc_type"],
        blinkImage: json["blink_image"],
      );

  Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
        "tilted_image": tiltedImage,
        "front_image": frontImage,
        "back_image": backImage,
        "card_number": cardNumber,
        "kyc_type": kycType,
        "blink_image": blinkImage,
      };
}

class DocumentUploadService {}

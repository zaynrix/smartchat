// class LoginResponse {
//   int? statusCode;
//   String? status;
//   String? message;
//   Data? data;
//
//   LoginResponse({this.statusCode, this.status, this.message, this.data});
//
//   LoginResponse.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['statusCode'] = this.statusCode;
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? accessToken;
//   String? refreshToken;
//   User? user;
//
//   Data({this.accessToken, this.refreshToken, this.user});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     accessToken = json['accessToken'];
//     refreshToken = json['refreshToken'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['accessToken'] = this.accessToken;
//     data['refreshToken'] = this.refreshToken;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//   String? sId;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? mobile;
//   int? balance;
//   bool? verifiedEmail;
//   bool? verifiedMobile;
//   VerifiedAddress? verifiedAddress;
//   VerifiedId? verifiedId;
//   int? role;
//   Address? address;
//   bool? isBlocked;
//
//   User(
//       {this.sId,
//         this.firstName,
//         this.lastName,
//         this.email,
//         this.mobile,
//         this.balance,
//         this.verifiedEmail,
//         this.verifiedMobile,
//         this.verifiedAddress,
//         this.verifiedId,
//         this.role,
//         this.address,
//         this.isBlocked});
//
//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     email = json['email'];
//     mobile = json['mobile'];
//     balance = json['balance'];
//     verifiedEmail = json['verifiedEmail'];
//     verifiedMobile = json['verifiedMobile'];
//     verifiedAddress = json['verifiedAddress'] != null
//         ? new VerifiedAddress.fromJson(json['verifiedAddress'])
//         : null;
//     verifiedId = json['verifiedId'] != null
//         ? new VerifiedId.fromJson(json['verifiedId'])
//         : null;
//     role = json['role'];
//     address =
//     json['address'] != null ? new Address.fromJson(json['address']) : null;
//     isBlocked = json['isBlocked'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['firstName'] = this.firstName;
//     data['lastName'] = this.lastName;
//     data['email'] = this.email;
//     data['mobile'] = this.mobile;
//     data['balance'] = this.balance;
//     data['verifiedEmail'] = this.verifiedEmail;
//     data['verifiedMobile'] = this.verifiedMobile;
//     if (this.verifiedAddress != null) {
//       data['verifiedAddress'] = this.verifiedAddress!.toJson();
//     }
//     if (this.verifiedId != null) {
//       data['verifiedId'] = this.verifiedId!.toJson();
//     }
//     data['role'] = this.role;
//     if (this.address != null) {
//       data['address'] = this.address!.toJson();
//     }
//     data['isBlocked'] = this.isBlocked;
//     return data;
//   }
// }
//
// class VerifiedAddress {
//   String? disapproveReason;
//   String? status;
//   String? addressDocumentType;
//   String? addressFile;
//   String? otherDocumentType;
//
//   VerifiedAddress(
//       {this.disapproveReason,
//         this.status,
//         this.addressDocumentType,
//         this.addressFile,
//         this.otherDocumentType});
//
//   VerifiedAddress.fromJson(Map<String, dynamic> json) {
//     disapproveReason = json['disapproveReason'];
//     status = json['status'];
//     addressDocumentType = json['addressDocumentType'];
//     addressFile = json['addressFile'];
//     otherDocumentType = json['otherDocumentType'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['disapproveReason'] = this.disapproveReason;
//     data['status'] = this.status;
//     data['addressDocumentType'] = this.addressDocumentType;
//     data['addressFile'] = this.addressFile;
//     data['otherDocumentType'] = this.otherDocumentType;
//     return data;
//   }
// }
//
// class VerifiedId {
//   String? disapproveReason;
//   String? status;
//   String? idDocumentType;
//   String? idNumber;
//   String? idFile;
//
//   VerifiedId(
//       {this.disapproveReason,
//         this.status,
//         this.idDocumentType,
//         this.idNumber,
//         this.idFile});
//
//   VerifiedId.fromJson(Map<String, dynamic> json) {
//     disapproveReason = json['disapproveReason'];
//     status = json['status'];
//     idDocumentType = json['idDocumentType'];
//     idNumber = json['idNumber'];
//     idFile = json['idFile'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['disapproveReason'] = this.disapproveReason;
//     data['status'] = this.status;
//     data['idDocumentType'] = this.idDocumentType;
//     data['idNumber'] = this.idNumber;
//     data['idFile'] = this.idFile;
//     return data;
//   }
// }
//
// class Address {
//   String? country;
//   String? city;
//   String? address1;
//   String? address2;
//
//   Address({this.country, this.city, this.address1, this.address2});
//
//   Address.fromJson(Map<String, dynamic> json) {
//     country = json['country'];
//     city = json['city'];
//     address1 = json['address1'];
//     address2 = json['address2'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['country'] = this.country;
//     data['city'] = this.city;
//     data['address1'] = this.address1;
//     data['address2'] = this.address2;
//     return data;
//   }
// }

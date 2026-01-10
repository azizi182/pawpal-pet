class Donation {
  String? donationId;
  String? donationType;
  String? donationAmount;
  String? donationDate;

  String? userId;
  String? userName;

  String? petId;
  String? receiverId;
  String? receiverName;

  Donation({
    this.donationId,
    this.donationType,
    this.donationAmount,
    this.donationDate,
    this.userId,
    this.userName,
    this.petId,
    this.receiverId,
    this.receiverName,
  });

  Donation.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
    donationType = json['donation_type'];
    donationAmount = json['donation_amount'];
    donationDate = json['donation_date'];
    userId = json['user_id'];
    userName = json['user_name'];
    petId = json['pet_id'];
    receiverId = json['receiver_id'];
    receiverName = json['receiver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['donation_type'] = donationType;
    data['donation_amount'] = donationAmount;
    data['donation_date'] = donationDate;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['pet_id'] = petId;
    data['receiver_id'] = receiverId;
    data['receiver_name'] = receiverName;
    return data;
  }
}

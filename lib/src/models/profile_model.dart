class ProfileModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String dob;
  final String relation;
  final String? photoUrl;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.relation,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'dob': dob,
      'gender': relation,
      'photoUrl': photoUrl,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      dob: map['dob'],
      relation: map['gender'],
      photoUrl: map['photoUrl'],
    );
  }
}

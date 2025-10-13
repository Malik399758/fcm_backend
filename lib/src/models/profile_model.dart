
class ProfileModel{
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String dob;
  final String relation;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.relation
});

  // model to firebase

 Map<String,dynamic> toMap(){
   return {
     'uid': uid,
     'name' : name,
     'phone' : phone,
     'email' : email,
     'dob' : dob,
     'gender' : relation,
   };
 }

 // firebase to model

 factory ProfileModel.fromMap(Map<String,dynamic> map){
   return ProfileModel(
       uid: map['uid'],
       name: map['name'],
       phone: map['phone'],
       email: map['email'],
       dob: map['dob'],
       relation: map['gender']
   );
 }
}
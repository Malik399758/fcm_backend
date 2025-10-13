
class ProfileModel{
  final String uid;
  final String name;

  ProfileModel({
    required this.uid,
    required this.name
});

  // model to firebase

 Map<String,dynamic> toMap(){
   return {
     'uid': uid,
     'name' : name
   };
 }

 // firebase to model

 factory ProfileModel.fromMap(Map<String,dynamic> map){
   return ProfileModel(
       uid: map['uid'],
       name: map['name']);
 }
}

class user_service {

  class UserData {
  final email;
  final photo;
  final first_name;
  final last_name;
  final province;
  final city;
  final educational_background;
  final certification;
  final work_experience;
  const UserData(this.email,this.photo,this.first_name, this.last_name,this.province,this.city,
  this.educational_background,this.certification,this.work_experience);
  }


  Stream<List<UserData>> getUserDataSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    //yield* FirebaseFirestore.instance.collection('profile').where('profile_id', isEqualTo: uid).snapshots();

    var profile = FirebaseFirestore.instance.collection('profile').where('profile_id', isEqualTo: uid).snapshots();
    var data = List<UserData>();
    await for (var profileSnapshot in profile) {
      for (var profileDoc in profileSnapshot.docs) {
        var ProfileData;
        var emailSnapshot = await FirebaseFirestore.instance.collection("hero").where('profile_id', isEqualTo: uid).get();
        var heroSnapshot = await FirebaseFirestore.instance.collection("hero_info").where('profile_id', isEqualTo: uid).get();
        var addressSnapshot = await FirebaseFirestore.instance.collection("address").where('profile_id', isEqualTo: uid).get();
        ProfileData = UserData(
          emailSnapshot.docs[0].get('email'),
          profileSnapshot.docs[0].get('photo'),
          profileSnapshot.docs[0].get('first_name'),
          profileSnapshot.docs[0].get('last_name'),
          addressSnapshot.docs[0].get('province'),
          addressSnapshot.docs[0].get('city'),
          heroSnapshot.docs[0].get('educational_background'),
          heroSnapshot.docs[0].get('certification'),
          heroSnapshot.docs[0].get('work_experience'),
        );

        data.add(ProfileData);
      }

      yield data;
    }


  }


}
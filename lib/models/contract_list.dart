import '../db/contact.dart';
import '../db/user.dart';

class ContractList {
  final int? id;
  final String? fid;
  final String? friendUsername;
  final String? friendAvatar;
  final int? friendLatestOnlineTime;

  const ContractList(
    this.id,
    this.fid,
    this.friendUsername,
    this.friendAvatar,
    this.friendLatestOnlineTime,
  );
}

Future<List<ContractList>> list() async {
  var lst = await getContactList();
  List<ContractList> cl = [];
  for (Contact c in lst) {
    Map<String, Object?>? user = await getUser(c.fid!);
    if(user.isEmpty){
      user = await getUserInfoFromServer(c.fid!);
    }
    if(user!.isNotEmpty){
      cl.add(ContractList(c.id, c.fid, user['username'] as String?,
          user['avatar'] as String?, user['latest_online'] as int?));
    }
  }
  return cl;
}

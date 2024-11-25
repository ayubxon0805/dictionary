import 'package:dictionary/services/hive_helper/adapter.dart';
import 'package:hive/hive.dart';

part 'group_model.g.dart';

@HiveType(typeId: 6, adapterName: HiveAdapters.savegroup)
class GroupModel extends HiveObject {
  @HiveField(0)
  String groupName;

  GroupModel({required this.groupName});
}

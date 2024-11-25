// ignore_for_file: file_names

import 'package:dictionary/services/hive_helper/adapter.dart';
import 'package:hive/hive.dart';
part 'hiveModel.g.dart';

@HiveType(typeId: 23, adapterName: HiveAdapters.vocabluary)
class HiveVocabluaryModel extends HiveObject {
  @HiveField(0)
  String eng;

  @HiveField(1)
  String uz;

  @HiveField(2)
  String name;

  @HiveField(3)
  String date;

  @HiveField(4)
  int unitIndex;

  HiveVocabluaryModel({
    required this.eng,
    required this.uz,
    required this.name,
    required this.date,
    required this.unitIndex,
  });

  factory HiveVocabluaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HiveVocabluaryModel(
      eng: json['eng'] ?? '',
      uz: json['uz'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      unitIndex: json['date'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'eng': eng,
        'uz': uz,
        'name': name,
        'date': date,
        'unitIndex': unitIndex,
      };
}

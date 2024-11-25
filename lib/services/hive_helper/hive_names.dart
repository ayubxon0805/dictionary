import 'package:dictionary/models/words_model/hiveModel.dart';
import 'package:dictionary/models/words_model/new_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  const HiveBoxes._();

  static final Box<HiveVocabluaryModel> allvocabluary =
      Hive.box(HiveBoxNames.allvocabluary);
  static final Box<NewModel> newWords = Hive.box(HiveBoxNames.newfeature);
  static final Box<dynamic> filterwords = Hive.box(HiveBoxNames.filterwords);

  static Future<void> clearAllBoxes() async {
    await Future.wait([]);
    allvocabluary.clear();
    filterwords.clear();
  }
}

class HiveBoxNames {
  static const String allvocabluary = 'allvocabluary';
  static const String staticNumber = 'staticNumber';
  static const String renamegroup = 'renamegroup';
  static const String newfeature = 'newfeature';
  static const String filterwords = 'filterwords';
}

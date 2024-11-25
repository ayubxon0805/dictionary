import 'package:dictionary/models/words_model/hiveModel.dart';
import 'package:dictionary/services/hive_helper/hive_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'daily_words_event.dart';
part 'daily_words_state.dart';

class DailyWordsBloc extends Bloc<DailyWordsEvent, DailyWordsState> {
  DailyWordsBloc() : super(DailyWordsInitial()) {
    on<AddDailyWordsEvent>(filterVocabluary);
  }
  Future<void> filterVocabluary(
    AddDailyWordsEvent event,
    Emitter<DailyWordsState> emit,
  ) async {
    emit(DailyProcessState());
    List<HiveVocabluaryModel> allVocabluary =
        HiveBoxes.allvocabluary.values.toList();
    if (allVocabluary.isNotEmpty) {
      int newcounter = 0;
      int oldCounter = 20;
      List<List<HiveVocabluaryModel>> baseUnits = [];
      List<HiveVocabluaryModel> j = [];
      for (int i = 0; i < allVocabluary.length; i++) {
        if (i < oldCounter && i >= newcounter) {
          j.add(allVocabluary[i]);
        } else {
          baseUnits.add(List<HiveVocabluaryModel>.from(j));
          j = [];
          newcounter += 20;
          oldCounter += 20;
          j.add(allVocabluary[i]);
        }
      }
      if (j.isNotEmpty) {
        baseUnits.add(List<HiveVocabluaryModel>.from(j));
      }

      emit(DailyWordsSuccessState(allwords: baseUnits));
    } else {
      emit(DailyFailureState());
    }
  }
}

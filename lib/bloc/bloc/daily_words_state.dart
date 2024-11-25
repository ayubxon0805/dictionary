part of 'daily_words_bloc.dart';

sealed class DailyWordsState {}

final class DailyWordsInitial extends DailyWordsState {}

class DailyWordsSuccessState extends DailyWordsState {
  final List<List<HiveVocabluaryModel>> allwords;
  DailyWordsSuccessState({required this.allwords});
}

class DailyProcessState extends DailyWordsState {}

class DailyFailureState extends DailyWordsState {}

import 'dart:math';
import 'package:dictionary/bloc/get_word/get_word_bloc.dart';
import 'package:dictionary/models/words_model/hiveModel.dart';
import 'package:dictionary/services/hive_helper/hive_names.dart';
import 'package:dictionary/services/isar_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/words_model/word.dart';

class RandomWordsScreen extends StatefulWidget {
  const RandomWordsScreen({super.key});
  @override
  State<RandomWordsScreen> createState() => _RandomWordsScreenState();
}

class _RandomWordsScreenState extends State<RandomWordsScreen> {
  int counter = 0;
  String en = '';
  String uz = '';
  bool isShow = false;
  bool isShow2 = false;
  FlutterTts flutterTts = FlutterTts();
  List<HiveVocabluaryModel> selectedWords = [];

  void _getRandomWordFromUnit(HiveVocabluaryModel unit) {
    if (unit.eng == null || unit.uz == null) return;

    final engWords = unit.eng.split(', ');
    final uzWords = unit.uz.split(', ');

    if (engWords.isEmpty || uzWords.isEmpty) return;

    final randomIndex = Random().nextInt(engWords.length);

    setState(() {
      en = engWords[randomIndex];
      uz = randomIndex < uzWords.length ? uzWords[randomIndex] : '';
      isShow = true; // Uz tilidagi matnni avtomatik ko'rinishga chiqarish
      isShow2 = true; // En tilidagi matnni avtomatik ko'rinishga chiqarish
    });
  }

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetWordBloc>(context).add(GetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<GetWordBloc, GetWordState>(
        builder: (context, state) {
          if (state is GetAllState) {
            List<Words> randomWords = state.allW;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HiveBoxes.allvocabluary.values.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Gorizontal scroll qilish
                          padding: const EdgeInsets.all(8),
                          itemCount: HiveBoxes.allvocabluary.values.length,
                          itemBuilder: (context, index) {
                            final unit =
                                HiveBoxes.allvocabluary.values.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0), // Kartalar oralig'i
                              child: InkWell(
                                onTap: () => _getRandomWordFromUnit(unit),
                                child: Container(
                                  width: 80, // Kenglik 70 piksel
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 87, 95, 101)
                                              .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Unit ${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 7, 67, 116),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Icon(
                                            color: Colors.grey,
                                            Icons.play_circle_fill_outlined,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Spacer(),
                Column(
                  children: [
                    isShow2 == true
                        ? Container(
                            height: 60,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit
                                    .scaleDown, // Matnni o‘lchovga moslashtirish
                                child: Text(
                                  en,
                                  style: GoogleFonts.comfortaa(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25, // Maksimal font o‘lchami
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Text(""),
                    isShow == true
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  uz,
                                  style: GoogleFonts.comfortaa(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 10,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () async {
                              if (en != "") {
                                textToSpeech(en);
                              }
                            },
                            child: Ink(
                              height: 100,
                              child: Image.asset("assets/images/vol.jpg"),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 10,
                          child: Text(""),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 7, 67, 116),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () async {
                            List<Words> all = await IsarService().getAllSura();
                            if (all.isNotEmpty) {
                              Words rand = randomWords[
                                  Random().nextInt(randomWords.length)];

                              en = rand.nameEn ?? "";
                              uz = rand.nameUz ?? "";
                              counter++;
                            } else if (all.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("You do'nt have words")),
                              );
                            }
                            setState(() {});
                          },
                          child: Center(
                            child: Text(
                              counter.toString(),
                              style: GoogleFonts.comfortaa(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 67, 116),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              if (isShow == true) {
                                isShow = false;
                              } else {
                                isShow = true;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Show Text Uz",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 67, 116),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              if (isShow2 == true) {
                                isShow2 = false;
                              } else {
                                isShow2 = true;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Show Text En",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }
}

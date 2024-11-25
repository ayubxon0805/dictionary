import 'package:dictionary/models/words_model/hiveModel.dart';
import 'package:dictionary/services/hive_helper/hive_names.dart';
import 'package:flutter/material.dart';

class HiveWordsPage extends StatefulWidget {
  const HiveWordsPage({super.key});

  @override
  State<HiveWordsPage> createState() => _HiveWordsPageState();
}

class _HiveWordsPageState extends State<HiveWordsPage> {
  List<HiveVocabluaryModel> allwords = HiveBoxes.allvocabluary.values.toList();
  final TextEditingController engController = TextEditingController();
  final TextEditingController uzController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Vocabulary',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/images/delete.png'),
              color: Color.fromARGB(255, 7, 67, 116),
            ),
            onPressed: _clearAllWords,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: allwords.length,
        itemBuilder: (context, unitIndex) {
          final unit = allwords[unitIndex];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                unit.name ?? 'Unit ${unit.unitIndex}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                ..._buildWordList(unit),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Word'),
                    onPressed: () => _showAddWordDialog(unitIndex),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build word items in a unit
  List<Widget> _buildWordList(HiveVocabluaryModel unit) {
    final engWords = unit.eng?.split(', ') ?? [];
    final uzWords = unit.uz?.split(', ') ?? [];

    return List.generate(engWords.length, (index) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          engWords[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          uzWords.length > index ? uzWords[index] : '',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditWordDialog(
                              unit, index, allwords.indexOf(unit));
                        },
                        iconSize: 20,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(unit.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return dateStr;
    }
  }

  // Add Word Dialog
  Future _showAddWordDialog(int unitIndex) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Add New Word',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(engController, 'English'),
              const SizedBox(height: 16),
              _buildTextField(uzController, 'Uzbek'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              engController.clear();
              uzController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newWordEng = engController.text.trim();
              final newWordUz = uzController.text.trim();
              if (newWordEng.isEmpty || newWordUz.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in both fields!')),
                );
                return;
              }

              final box = HiveBoxes.allvocabluary;
              final currentUnit = box.getAt(unitIndex);

              if (currentUnit != null) {
                final updatedUnit = HiveVocabluaryModel(
                  name: currentUnit.name,
                  date: DateTime.now().toIso8601String(),
                  unitIndex: currentUnit.unitIndex,
                  eng: currentUnit.eng != null
                      ? "${currentUnit.eng}, $newWordEng"
                      : newWordEng,
                  uz: currentUnit.uz != null
                      ? "${currentUnit.uz}, $newWordUz"
                      : newWordUz,
                );
                final newWord = HiveVocabluaryModel(
                  eng: engController.text,
                  uz: uzController.text,
                  name: 'Unit ${unitIndex + 1}',
                  unitIndex: unitIndex + 1,
                  date: DateTime.now().toIso8601String(), // To'g'ri formatlash
                );

                box.putAt(unitIndex, updatedUnit);
              }

              setState(() {
                allwords = box.values.toList();
              });

              engController.clear();
              uzController.clear();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Word Added!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF000000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build input field
  Widget _buildTextField(TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: placeholder,
        labelStyle: TextStyle(color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[200]!),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
    );
  }

  // Edit Word Dialog
  void _showEditWordDialog(
      HiveVocabluaryModel unit, int wordIndex, int unitIndex) {
    engController.text = unit.eng?.split(', ')[wordIndex] ?? '';
    uzController.text = unit.uz?.split(', ')[wordIndex] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Edit Word',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 7, 67, 116),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(engController, 'English'),
              const SizedBox(height: 16),
              _buildTextField(uzController, 'Uzbek'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              engController.clear();
              uzController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedEng = engController.text.trim();
              final updatedUz = uzController.text.trim();

              if (updatedEng.isEmpty || updatedUz.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in both fields!')),
                );
                return;
              }

              final box = HiveBoxes.allvocabluary;
              final currentUnit = box.getAt(unitIndex);

              if (currentUnit != null) {
                // So'zlarni yangilash
                final engWords = currentUnit.eng?.split(', ') ?? [];
                final uzWords = currentUnit.uz?.split(', ') ?? [];

                if (engWords.length > wordIndex)
                  engWords[wordIndex] = updatedEng;
                if (uzWords.length > wordIndex) uzWords[wordIndex] = updatedUz;

                final updatedUnit = HiveVocabluaryModel(
                  name: currentUnit.name,
                  date: currentUnit.date,
                  unitIndex: currentUnit.unitIndex,
                  eng: engWords.join(', '),
                  uz: uzWords.join(', '),
                );

                box.putAt(unitIndex, updatedUnit);

                setState(() {
                  allwords = box.values.toList();
                });

                engController.clear();
                uzController.clear();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Word Edited!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 7, 67, 116),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Clear all words
  void _clearAllWords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear All Words',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 7, 67, 116),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: const Text(
            'Are you sure you want to delete all words?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HiveBoxes.allvocabluary.clear();
              setState(() {
                allwords = [];
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All words have been deleted!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 67, 116),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

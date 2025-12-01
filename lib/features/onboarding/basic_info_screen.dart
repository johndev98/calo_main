import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  String gender = "male";

  int? birthYear; // null khi chưa chọn
  int? height;
  int? weight;
  // mở bottom sheet picker
  void _openPicker({
    required List<int> items,
    required int initial,
    required ValueChanged<int> onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CupertinoColors.systemBackground,
        ),
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: items.indexOf(initial),
                ),
                onSelectedItemChanged: (index) => onSelected(items[index]),
                children: items
                    .map((e) => Text("$e", style: TextStyle(fontSize: 30)))
                    .toList(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF9114),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "xong",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Back + Progress
              Row(
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.25,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFFFA726),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // Giới tính
              GenderSelector(
                maxWidth: 400,
                value: gender,
                onChanged: (v) => setState(() => gender = v),
              ),
              const SizedBox(height: 30),
              SelectField(
                maxWidth: 400,
                label: "Năm sinh",
                value: birthYear,
                items: List.generate(60, (i) => 1965 + i),
                defaultInitial: 1995,
                onChanged: (v) => setState(() => birthYear = v),
                openPicker: () {
                  _openPicker(
                    items: List.generate(60, (i) => 1965 + i),
                    initial: birthYear ?? 1995,
                    onSelected: (v) => setState(() => birthYear = v),
                  );
                },
              ),

              const SizedBox(height: 30),

              SelectField(
                maxWidth: 400,
                label: "Cân nặng",
                value: weight,
                unit: "kg",
                items: List.generate(120, (i) => 20 + i),
                defaultInitial: 60,
                onChanged: (v) => setState(() => weight = v),
                openPicker: () {
                  _openPicker(
                    items: List.generate(120, (i) => 20 + i),
                    initial: weight ?? 60,
                    onSelected: (v) => setState(() => weight = v),
                  );
                },
              ),

              const SizedBox(height: 30),

              SelectField(
                maxWidth: 400,
                label: "Chiều cao",
                value: height,
                unit: "cm",
                items: List.generate(120, (i) => 120 + i),
                defaultInitial: 170,
                onChanged: (v) => setState(() => height = v),
                openPicker: () {
                  _openPicker(
                    items: List.generate(120, (i) => 120 + i),
                    initial: height ?? 170,
                    onSelected: (v) => setState(() => height = v),
                  );
                },
              ),

              const Spacer(),

              // Button Continue
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "Tiếp tục",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectField extends StatelessWidget {
  final String label;
  final int? value;
  final String? unit;
  final List<int> items;
  final int defaultInitial;
  final ValueChanged<int> onChanged;
  final VoidCallback openPicker;
  final double? maxWidth;

  const SelectField({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.items,
    required this.defaultInitial,
    required this.onChanged,
    required this.openPicker,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // căn giữa toàn bộ container
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // label sát container
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: openPicker,
              child: value == null
                  ? _selectBox("Chọn $label")
                  : _valueBox("$value${unit != null ? " $unit" : ""}"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectBox(String text) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
      ),
    ),
  );

  Widget _valueBox(String text) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: const Color(0xFFFFA726),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

//

class GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final double? maxWidth;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // label sát container
          children: [
            const Text(
              "Giới tính",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _genderButton(
                  label: "Nam",
                  isActive: value == "male",
                  onTap: () => onChanged("male"),
                ),
                const SizedBox(width: 12),
                _genderButton(
                  label: "Nữ",
                  isActive: value == "female",
                  onTap: () => onChanged("female"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFA726) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

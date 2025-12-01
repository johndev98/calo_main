import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';

final _currentYear = DateTime.now().year;
final _birthYears = List.generate(101, (i) => _currentYear - i); // 100 năm
final _weights = List.generate(281, (i) => 20 + i); // 20..300
final _heights = List.generate(121, (i) => 100 + i); // 100..220

class BasicInfoScreen extends ConsumerWidget {
  const BasicInfoScreen({super.key});

  void _openPickerGeneric({
    required BuildContext context,
    required List<int> items,
    int? currentValue,
    required ValueChanged<int> onSelected,
    String? unit,
  }) {
    // nếu currentValue null thì lấy giá trị mặc định là items đầu tiên
    int selectedValue = currentValue ?? items.first;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        constraints: BoxConstraints(maxWidth: 400),
        height: 300,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: items.indexOf(selectedValue),
                    ),
                    onSelectedItemChanged: (i) => selectedValue = items[i],
                    children: items
                        .map(
                          (e) => Center(
                            child: Text(
                              "$e",
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (unit != null)
                    Positioned(
                      right: 70,
                      child: Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onSelected(selectedValue); // luôn chọn giá trị hiện tại
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9114),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Xong",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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

  void _onNextPressed(BuildContext context, UserProfile profile) {
    // Danh sách các trường chưa chọn
    List<String> missing = [];

    if (profile.gender.name == "none") missing.add("giới tính");
    if (profile.birthYear == null) missing.add("năm sinh");
    if (profile.weight == null) missing.add("cân nặng");
    if (profile.height == null) missing.add("chiều cao");

    if (missing.isNotEmpty) {
      // Hiển thị dialog với các mục chưa chọn
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Thiếu thông tin"),
          content: Text("Bạn chưa chọn ${missing.join(', ')}"),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      // Tất cả đã chọn -> chuyển sang màn hình tiếp theo
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('data')),
          ), // Thay bằng màn hình tiếp theo của bạn
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    // Kiểm tra tất cả giá trị
    final isComplete =
        profile.gender.name != "none" &&
        profile.birthYear != null &&
        profile.weight != null &&
        profile.height != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),

              // Progress + Back
              Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                      onTap: () {
                        notifier.reset();
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Color(0xFFFFA726)),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gender
                    GenderSelector(
                      maxWidth: 400,
                      value: profile.gender.name,
                      onChanged: (v) {
                        notifier.update(
                          gender: v == "male" ? Gender.male : Gender.female,
                        );
                      },
                    ),

                    // Năm sinh
                    SelectField(
                      maxWidth: 400,
                      label: "Năm sinh",
                      value: profile.birthYear,
                      items: _birthYears,
                      defaultInitial: 2000,
                      onChanged: (v) => notifier.update(birthYear: v),
                      openPicker: () {
                        _openPickerGeneric(
                          context: context,
                          items: _birthYears,
                          currentValue: profile.birthYear ?? 2000,
                          onSelected: (v) => notifier.update(birthYear: v),
                        );
                      },
                    ),

                    // Cân nặng
                    SelectField(
                      maxWidth: 400,
                      label: "Cân nặng",
                      value: profile.weight,
                      unit: "kg",
                      items: _weights,
                      defaultInitial: 60,
                      onChanged: (v) => notifier.update(weight: v),
                      openPicker: () {
                        _openPickerGeneric(
                          context: context,
                          items: _weights,
                          currentValue: profile.weight ?? 60,
                          unit: "kg",
                          onSelected: (v) => notifier.update(weight: v),
                        );
                      },
                    ),

                    // Chiều cao
                    SelectField(
                      maxWidth: 400,
                      label: "Chiều cao",
                      value: profile.height,
                      unit: "cm",
                      items: _heights,
                      defaultInitial: 170,
                      onChanged: (v) => notifier.update(height: v),
                      openPicker: () {
                        _openPickerGeneric(
                          context: context,
                          items: _heights,
                          currentValue: profile.height ?? 170,
                          unit: "cm",
                          onSelected: (v) => notifier.update(height: v),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Continue Button
              GestureDetector(
                onTap: () => _onNextPressed(context, profile),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: isComplete
                        ? const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                          )
                        : null,
                    color: isComplete ? null : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "Tiếp tục",
                      style: TextStyle(
                        color: isComplete ? Colors.white : Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch, // label sát container
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
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
      borderRadius: BorderRadius.circular(15),
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
      borderRadius: BorderRadius.circular(15),
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
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch, // label sát container
          children: [
            const Text(
              "Giới tính",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
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
            borderRadius: BorderRadius.circular(15),
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

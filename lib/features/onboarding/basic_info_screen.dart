import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../theme/app_theme.dart';

final _currentYear = DateTime.now().year;
final _birthYears = List.generate(101, (i) => _currentYear - i);
final _weights = List.generate(281, (i) => 20 + i);
final _heights = List.generate(121, (i) => 100 + i);

class BasicInfoScreen extends ConsumerWidget {
  const BasicInfoScreen({super.key});

  void _openPickerGeneric({
    required BuildContext context,
    required List<int> items,
    int? currentValue,
    required ValueChanged<int> onSelected,
    String? unit,
  }) {
    final mix = MixTheme.of(context);
    int selectedValue = currentValue ?? items.first;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        constraints: const BoxConstraints(maxWidth: 400),
        height: 300,
        decoration: BoxDecoration(
          color: mix.colors[AppTheme.$surface],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                              style: TextStyle(
                                fontSize: 30,
                                color: mix.colors[AppTheme.$textPrimary],
                              ),
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
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: mix.colors[AppTheme.$textPrimary],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onSelected(selectedValue);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: mix.colors[AppTheme.$primary],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Xong",
                    style: mix.textStyles[AppTheme.$textButton]?.copyWith(
                      color: Colors.white,
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
    List<String> missing = [];

    if (profile.gender.name == "none") missing.add("giới tính");
    if (profile.birthYear == null) missing.add("năm sinh");
    if (profile.weight == null) missing.add("cân nặng");
    if (profile.height == null) missing.add("chiều cao");

    if (missing.isNotEmpty) {
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
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('data'))),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    final mix = MixTheme.of(context);

    final isComplete =
        profile.gender.name != "none" &&
        profile.birthYear != null &&
        profile.weight != null &&
        profile.height != null;

    return Scaffold(
      backgroundColor: mix.colors[AppTheme.$background],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mix.spaces[AppTheme.$spacing] ?? 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: mix.spaces[AppTheme.$spacingSmall] ?? 10),

              // Progress + Back
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: mix.colors[AppTheme.$textPrimary],
                      ),
                      onTap: () => notifier.reset(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            mix.radii[AppTheme.$radiusSmall] ??
                                const Radius.circular(8),
                          ),
                          child: LinearProgressIndicator(
                            value: 0.25,
                            backgroundColor: mix.colors[AppTheme.$surface],
                            valueColor: AlwaysStoppedAnimation(
                              mix.colors[AppTheme.$gradient1],
                            ),
                            minHeight: 8,
                          ),
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
                    Text(
                      "Thông tin cá nhân",
                      style: mix.textStyles[AppTheme.$heading],
                    ),

                    GenderSelector(
                      maxWidth: 400,
                      value: profile.gender.name,
                      onChanged: (v) {
                        notifier.update(
                          gender: v == "male" ? Gender.male : Gender.female,
                        );
                      },
                    ),

                    SelectField(
                      textAction: "Chọn năm sinh",
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

                    SelectField(
                      textAction: "Chọn cân nặng",
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

                    SelectField(
                      textAction: "Chọn chiều cao",
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
                  constraints: const BoxConstraints(maxWidth: 400),
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: isComplete
                        ? LinearGradient(
                            colors: [
                              mix.colors[AppTheme.$gradient1]!,
                              mix.colors[AppTheme.$gradient2]!,
                            ],
                          )
                        : null,
                    color: isComplete ? null : mix.colors[AppTheme.$surface],
                    borderRadius: BorderRadius.all(
                      mix.radii[AppTheme.$radiusLarge]!,
                    ),
                    border: Border.all(
                      color: mix.colors[AppTheme.$border]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Tiếp tục",
                      style: mix.textStyles[AppTheme.$textButton]?.copyWith(
                        color: isComplete ? Colors.white : null,
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
  final String? textAction;

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
    this.textAction,
  });

  @override
  Widget build(BuildContext context) {
    final mix = MixTheme.of(context);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Column(
          spacing: mix.spaces[AppTheme.$spacingSmall] ?? 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: mix.textStyles[AppTheme.$label]),
            GestureDetector(
              onTap: openPicker,
              child: value == null
                  ? _selectBox(mix, "$textAction")
                  : _valueBox(mix, "$value${unit != null ? " $unit" : ""}"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectBox(MixThemeData mix, String text) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: mix.colors[AppTheme.$surface],
      borderRadius: BorderRadius.all(mix.radii[AppTheme.$radiusLarge]!),
    ),
    child: Center(
      child: Text(text, style: mix.textStyles[AppTheme.$actionText]),
    ),
  );

  Widget _valueBox(MixThemeData mix, String text) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: mix.colors[AppTheme.$primary],
      borderRadius: BorderRadius.all(mix.radii[AppTheme.$radiusLarge]!),
    ),
    child: Center(
      child: Text(
        text,
        style: mix.textStyles[AppTheme.$actionText]?.copyWith(
          color: Colors.white,
          fontFamily: "Open Sans",
        ),
      ),
    ),
  );
}

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
    final mix = MixTheme.of(context);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Column(
          spacing: mix.spaces[AppTheme.$spacingSmall] ?? 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Giới tính", style: mix.textStyles[AppTheme.$label]),
            Row(
              children: [
                GenderButton(
                  label: "Nam",
                  isActive: value == "male",
                  onTap: () => onChanged("male"),
                ),
                const SizedBox(width: 12),
                GenderButton(
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
}

class GenderButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const GenderButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mix = MixTheme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isActive
                ? mix.colors[AppTheme.$primary]
                : mix.colors[AppTheme.$surface],
            borderRadius: BorderRadius.all(mix.radii[AppTheme.$radiusLarge]!),
          ),
          child: Center(
            child: Text(
              label,
              style: mix.textStyles[AppTheme.$actionText]?.copyWith(
                color: isActive ? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

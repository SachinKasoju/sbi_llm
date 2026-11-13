import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_main_model.dart';
import '../../models/course_language_model.dart';
import '../../models/course_levels_model.dart';
import '../../models/sub_category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/course_language_provider.dart';
import '../../providers/course_levels_provider.dart';
import '../../providers/search_filter_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/sub_category_provider.dart';
import 'search_result_page.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';


class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryProvider.notifier).mainCategory();
      ref.read(courseLanguageProvider.notifier).courseLanguages();
      ref.read(courseLevelsProvider.notifier).courseLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(searchFilterProvider);
    final filterNotifier = ref.read(searchFilterProvider.notifier);

    final categories = ref.watch(categoryProvider).data ?? [];
    final subCategories = ref.watch(subCategoryProvider).data ?? [];
    final languages = ref.watch(courseLanguageProvider).data ?? [];
    final levels = ref.watch(courseLevelsProvider).data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildLabel('Search'),
            TextField(
              onChanged: filterNotifier.setQuery,
              decoration: _inputDecoration('Search Courses'),
              style: appTextStyle(font: 'lexend'),
            ),
            const SizedBox(height: 20),
            _buildLabel('Category'),
            _buildDropdown<CategoryModel>(
              value: filterState.category,
              items: categories,
              hint: 'Select Category',
              onChanged: (val) {
                filterNotifier.setCategory(val);
                if (val != null) {
                  ref.read(subCategoryProvider.notifier).getSubCategories(val.slug);
                }
              },
              itemBuilder: (cat) => cat.name,
            ),
            const SizedBox(height: 20),
            _buildLabel('Sub Category'),
            _buildDropdown<SubcategoryModel>(
              value: filterState.subCategory,
              items: subCategories,
              hint: 'Select Sub Category',
              onChanged: filterNotifier.setSubCategory,
              itemBuilder: (sub) => sub.name,
            ),
            const SizedBox(height: 20),
            _buildLabel('Pricing'),
            _buildDropdown<String>(
              value: filterState.pricing,
              items: const ['All', 'Paid', 'Free'],
              hint: 'Select Pricing',
              onChanged: (val) => filterNotifier.setPricing(val ?? 'All'),
              itemBuilder: (p) => p,
            ),
            const SizedBox(height: 20),
            _buildLabel('Language'),
            _buildDropdown<LanguageModel>(
              value: filterState.language,
              items: languages,
              hint: 'Select Language',
              onChanged: filterNotifier.setLanguage,
              itemBuilder: (lang) => lang.name,
            ),
            const SizedBox(height: 20),
            _buildLabel('Level'),
            _buildDropdown<LevelModel>(
              value: filterState.level,
              items: levels,
              hint: 'Select Level',
              onChanged: filterNotifier.setLevel,
              itemBuilder: (lvl) => lvl.name,
            ),
            const SizedBox(height: 20),
            _buildLabel('Rating'),
            _buildDropdown<int>(
              value: filterState.rating,
              items: const [1, 2, 3, 4, 5],
              hint: 'Select Rating',
              onChanged: filterNotifier.setRating,
              itemBuilder: (r) => r.toString(),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => filterNotifier.clear(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Clear',
                      style: appTextStyle(
                        font: 'lexend',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchResultPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Search',
                      style: appTextStyle(
                        font: 'lexend',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: appTextStyle(
          font: 'lexend',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: appTextStyle(font: 'lexend', color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required void Function(T?) onChanged,
    required String Function(T) itemBuilder,
  }) {
    // Ensure unique items and that the value exists in the list to prevent crashes
    final uniqueItems = items.toSet().toList();
    final T? effectiveValue = (value != null && uniqueItems.contains(value)) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: effectiveValue,
          hint: Text(
            hint,
            style: appTextStyle(font: 'lexend', color: Colors.grey, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          onChanged: onChanged,
          items: uniqueItems.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemBuilder(item),
                style: appTextStyle(font: 'lexend', fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

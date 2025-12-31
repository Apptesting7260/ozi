
import '../../../../../core/appExports/app_export.dart';
import '../provider/filter_provider.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterProvider(),
      child: const _FiltersContent(),
    );
  }
}

class _FiltersContent extends StatelessWidget {
  const _FiltersContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilterProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          height: 54,
          text: "Apply Filters",
          borderRadius: BorderRadius.circular(60),
          color: provider.canApply
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.35),
          onPressed: () {}
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),

              hBox(24),

              /// SORT BY
              Text(
                "Sort By",
                style: AppFontStyle.text_14_600(AppColors.darkText),
              ),
              hBox(12),

              Row(
                children: [
                  _sortChip(
                    title: "Active",
                    selected: provider.active == true,
                    onTap: () => provider.selectStatus(true),
                  ),
                  wBox(10),
                  _sortChip(
                    title: "Inactive",
                    selected: provider.active == false,
                    onTap: () => provider.selectStatus(false),
                  ),
                ],
              ),


              hBox(24),

              /// CATEGORIES
              Text(
                "Categories",
                style: AppFontStyle.text_14_600(AppColors.darkText),
              ),
              hBox(12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: provider.allCategories.map((category) {
                  final selected =
                  provider.selectedCategories.contains(category);

                  return GestureDetector(
                    onTap: () => provider.toggleCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : AppColors.fieldBgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        category,
                        style: AppFontStyle.text_12_500(
                          selected
                              ? AppColors.white
                              : AppColors.darkText,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEFEFEF),
              ),
              padding: REdgeInsets.all(14),
              child: CustomImage(path: ImageConstants.back),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              "Filters",
              style: AppFontStyle.text_18_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.bold,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () =>
              context.read<FilterProvider>().clearAll(),
          child: Text(
            "Clear All",
            style: AppFontStyle.text_14_500(AppColors.primary, fontFamily: AppFontFamily.medium),
          ),
        ),
      ],
    );
  }

  /// ---------------- SORT CHIP ----------------
  Widget _sortChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(30),
          // border: Border.all(
          //   color: selected
          //       ? AppColors.primary
          //       : AppColors.grey.withOpacity(0.3),
          // ),
        ),
        child: Text(
          title,
          style: AppFontStyle.text_12_500(
            selected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

}

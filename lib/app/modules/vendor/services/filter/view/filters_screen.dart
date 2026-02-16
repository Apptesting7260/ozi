import 'package:ozi/app/data/models/all_services_model_vendor.dart';
import '../../../../../core/appExports/app_export.dart';
import '../provider/filter_provider.dart';

class FiltersScreen extends StatelessWidget {
  final List<ServiceCategory> categories;
  final bool? initialStatus;
  final String? initialCategoryId;

  const FiltersScreen({
    super.key,
    required this.categories,
    this.initialStatus,
    this.initialCategoryId,
  });


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterProvider(
        categories,
        initialStatus: initialStatus,
        initialCategoryId: initialCategoryId,
      ),

      child: _FiltersContent(categories: categories),
    );
  }
}

class _FiltersContent extends StatelessWidget {
  final List<ServiceCategory> categories;

  const _FiltersContent({required this.categories});

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
          onPressed: provider.canApply
              ? () {
                  Navigator.pop(context, {
                    "status": provider.active,
                    "categoryId": provider.selectedCategories.isNotEmpty
                        ? provider.selectedCategories.first.id
                        : null,
                  });
                  if (kDebugMode) {
                    print(
                      "Filter Id Selected = ${provider.selectedCategories.first.id}",
                    );
                  }
                }
              : null,
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

              // SORT BY
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

              // CATEGORIES
              Text(
                "Categories",
                style: AppFontStyle.text_14_600(AppColors.darkText),
              ),
              hBox(12),

              provider.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : provider.allCategories.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("No categories found"),
                    )
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: provider.allCategories.map((category) {
                        final selected = provider.selectedCategories.contains(
                          category,
                        );

                        return GestureDetector(
                          onTap: () => provider.toggleCategory(category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
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
                              category.categoryName ?? "",
                              style: AppFontStyle.text_12_500(
                                selected ? AppColors.white : AppColors.darkText,
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

  // ---------------- HEADER ----------------
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
          onPressed: () {
            final provider = context.read<FilterProvider>();
            provider.clearAll();

            Navigator.pop(context, {"status": null, "categoryId": null});
          },
          child: Text(
            "Clear All",
            style: AppFontStyle.text_14_500(
              AppColors.primary,
              fontFamily: AppFontFamily.medium,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- SORT CHIP ----------------
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
          color: selected ? AppColors.primary : AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(30),
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

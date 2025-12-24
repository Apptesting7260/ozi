
import 'package:ozi/app/shared/widgets/custom_app_bar.dart';

import '../../../../../core/appExports/app_export.dart';
import '../provider/ServiceCategoryProvider.dart';

class ServiceCategory extends StatelessWidget {
  const ServiceCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceCategoryProvider(),
      child: const _SelectServiceCategoriesContent(),
    );
  }
}

class _SelectServiceCategoriesContent extends StatelessWidget {
  const _SelectServiceCategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Tailor Services",
      "Entertainment & Event",
      "Towing Services",
      "Cleaning",
      "Handy Works",
      "Food",
      "Engineering",
      "Tutoring",
      "Painting",
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: _bottomButton(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             CustomAppBar(title: 'Select Service Categories'),

              Center(
                child: Text(
                  "Step 1 of 6",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
              ),

              hBox(18),
              Text(
                maxLines: 3,
                "Choose the services you want to offer. You can select multiple categories.",
                style: AppFontStyle.text_14_400(AppColors.grey),
              ),

              hBox(18),

              /// LIST OF CATEGORIES
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, index) {
                    return _categoryItem(
                        context: context, title: categories[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- CATEGORY ITEM ----------------
  Widget _categoryItem({
    required BuildContext context,
    required String title,
  }) {
    return Consumer<ServiceCategoryProvider>(
      builder: (context, provider, _) {
        bool selected = provider.isSelected(title);

        return GestureDetector(
          onTap: () => provider.toggleCategory(title),
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: .08)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                width: 1.3,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppFontStyle.text_15_500(
                selected ? AppColors.darkText : AppColors.darkText,
                fontFamily: AppFontFamily.medium,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------------- BOTTOM BUTTON ----------------
  Widget _bottomButton(BuildContext context) {
    return Consumer<ServiceCategoryProvider>(
      builder: (context, provider, _) {
        int count = provider.selected.length;

        return Padding(
          padding:  EdgeInsets.all(20),
          child: CustomButton(
            height: 54,
            text: "Continue ($count selected)",
            color: count > 0
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: .30),
             onPressed: count > 0 ? () {} : () {},

        ),
        );
      },
    );
  }
}

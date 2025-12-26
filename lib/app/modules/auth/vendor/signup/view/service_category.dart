import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
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
                "Choose the services you want to offer. You can select multiple categories.",
                style: AppFontStyle.text_14_400(AppColors.grey),
              ),

              hBox(18),

              /// CATEGORY LIST
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    return _categoryItem(
                      context: context,
                      title: categories[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CATEGORY ITEM ----------------
  Widget _categoryItem({
    required BuildContext context,
    required String title,
  }) {
    return Consumer<ServiceCategoryProvider>(
      builder: (context, provider, _) {
        final selected = provider.isSelected(title);

        return GestureDetector(
          onTap: () => provider.toggleCategory(title),
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
                width: 1.3,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppFontStyle.text_15_500(
                AppColors.darkText,
                fontFamily: AppFontFamily.medium,
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- BOTTOM BUTTON ----------------
  Widget _bottomButton(BuildContext context) {
    return Consumer<ServiceCategoryProvider>(
      builder: (context, provider, _) {
        final count = provider.selected.length;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: CustomButton(
            text: "Continue ($count selected)",
            color: count > 0
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),

            onPressed: () {
              if (count == 0) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceDetailsScreen(
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

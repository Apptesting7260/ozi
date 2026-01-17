import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../model/category_model.dart';
import '../../service details/view/ServiceDetailScreen.dart';
import '../provider/category_detail_provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Data category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryDetailProvider(category),
      child: CategoryDetailView(category: category),
    );
  }
}

class CategoryDetailView extends StatelessWidget {
  final Data category;

  const CategoryDetailView({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryDetailProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomAppBar(
                title: category.categoryName ?? "",
              ),
            ),
            Expanded(
              child: provider.subcategories.isEmpty
                  ? Center(
                child: Text(
                  'No subcategories available',
                  style: AppFontStyle.text_16_400(AppColors.grey),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: provider.subcategories.length,
                  itemBuilder: (context, index) {
                    final sub = provider.subcategories[index];
                    return _buildSubCategoryCard(context, sub, index + 1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryCard(
      BuildContext context,
      Subcategories sub,
      int index,
      ) {
    String formattedIndex = index < 10 ? '0$index' : '$index';

    return GestureDetector(
      onTap: () {
        debugPrint("Subcategory tapped: ${sub.categoryName}");
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.lightGrey,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  formattedIndex,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailScreen(
                            service: sub,
                            categoryId: sub.parentId ?? 0,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      padding: REdgeInsets.all(14),
                      child: CustomImage(path: ImageConstants.rightBack),
                    ),
                  ),
                ),
              ],
            ),
            hBox(12),
            Expanded(
              child: Text(
                sub.categoryName ?? "",
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
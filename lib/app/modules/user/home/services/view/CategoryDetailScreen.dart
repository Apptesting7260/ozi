import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/CategoryDetailProvider.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailScreen({
    super.key,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryDetailProvider(categoryTitle),
      child: CategoryDetailView(categoryTitle: categoryTitle),
    );
  }
}

class CategoryDetailView extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailView({
    super.key,
    required this.categoryTitle,
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
              child:  CustomAppBar(
                title: categoryTitle,
              ),
            ),

            Expanded(
              child: provider.services.isEmpty
                  ? Center(
                child: Text(
                  'No services available',
                  style: AppFontStyle.text_16_400(AppColors.grey),
                ),
              )
                  : Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(

                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: provider.services.length,
                  itemBuilder: (context, index) {
                    final service = provider.services[index];
                    return _buildServiceCard(
                      context,
                      service,
                      index + 1,
                      provider,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context,
      Service service,
      int index,
      CategoryDetailProvider provider,
      ) {
    String formattedIndex = index <10 ? '0$index' : '$index';

    return GestureDetector(
      onTap: () => provider.onServiceTap(service, context),
      child: Container(
        padding:  EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:  AppColors.lightGrey,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedIndex,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary.withValues(alpha: 0.5),
                    height: 1.0,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: CustomImage(path: ImageConstants.rightBack)
                  ),
                ),
              ],
            ),
           hBox(12),
            Text(
              service.name,
              style: AppFontStyle.text_16_600(
                AppColors.black,
                fontFamily: AppFontFamily.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
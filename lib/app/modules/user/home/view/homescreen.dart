import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_shimmer_box.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/HomeScreenProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeScreenProvider>().loadOnce();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenView();
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, provider),
                SizedBox(height: 10),
                _buildSearchBar(context, provider),
                SizedBox(height: 12),
                _buildSectionTitle(),
                SizedBox(height: 8),
                _buildServiceGrid(context, provider),
                SizedBox(height: 10),
                _buildBecomeProviderCard(context, provider),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeScreenProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Hello ",
                    style: AppFontStyle.text_24_500(
                      AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: provider.userName,
                    style: AppFontStyle.text_24_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.bold,
                    ),
                  ),
                  TextSpan(
                    text: "!",
                    style: AppFontStyle.text_24_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () => provider.onLocationTap(context),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    provider.selectedLocation,
                    style: AppFontStyle.text_14_400(
                      AppColors.grey,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
        profileAvatarStatic(
          imageUrl: "https://images.unsplash.com/photo-1527980965255-d3b416303d12",
          size: 50,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeScreenProvider provider) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () => provider.onSearchTap(context),
      hintText: "Search...",
      prefix: Padding(
        padding: EdgeInsets.all(12.0),
        child: CustomImage(
          path: ImageConstants.search,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Select What You Need',
      style: AppFontStyle.text_20_600(
        AppColors.black,
        fontFamily: AppFontFamily.bold,
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context, HomeScreenProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: provider.serviceCategories.length,
      itemBuilder: (context, index) {
        final category = provider.serviceCategories[index];
        return _buildServiceCard(context, category, provider);
      },
    );
  }

  Widget _buildServiceCard(
      BuildContext context,
      ServiceCategory category,
      HomeScreenProvider provider,
      ) {
    return GestureDetector(
      onTap: () => provider.onCategoryTap(category.title, context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: category.imagePath,
                fit: BoxFit.cover,
                placeholder: (_, __) => ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  radius: 12,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                category.title,
                style: AppFontStyle.text_14_500(
                  AppColors.white,
                  fontFamily: AppFontFamily.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBecomeProviderCard(
      BuildContext context,
      HomeScreenProvider provider,
      ) {
    return GestureDetector(
      onTap: () => provider.onBecomeProviderTap(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Become A Service\nProvider',
                        style: AppFontStyle.text_16_700(
                          AppColors.white,
                          fontFamily: AppFontFamily.bold,
                        ),
                      ),
                      hBox(6),
                      _buildBulletPoint('Get everyday \nexclusive orders'),
                      _buildBulletPoint('Earn more Revenue'),
                      _buildBulletPoint('Get Rated and tips \nfrom your customers'),
                      hBox(6),
                      CustomButton(
                        onPressed: () => provider.onBecomeProviderTap(context),
                        text: 'Apply Now',
                        textStyle: AppFontStyle.text_12_600(
                          AppColors.black,
                          fontFamily: AppFontFamily.semiBold,
                        ),
                        width: 120,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                ImageConstants.homeService,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 6,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppFontStyle.text_13_400(AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileAvatarStatic({
    required String imageUrl,
    double size = 95,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.person,
              size: size * 0.5,
              color: AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
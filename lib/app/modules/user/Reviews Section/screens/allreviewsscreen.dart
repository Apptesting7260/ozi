import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_image_path_helper.dart';
import '../../../../core/constants/app_urls.dart';
import '../provider/reviewsprovider.dart';
import '../model/reviewmodel.dart';

class AllReviewsScreen extends StatelessWidget {
  final String VendorId;
  const AllReviewsScreen({super.key, required this.VendorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewsProvider()..fetchReviews(VendorId),
      child: AllReviewsView(vendorId: VendorId),
    );
  }
}

class AllReviewsView extends StatefulWidget {
  final String vendorId;
  const AllReviewsView({super.key, required this.vendorId});

  @override
  State<AllReviewsView> createState() => _AllReviewsViewState();
}

class _AllReviewsViewState extends State<AllReviewsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReviewsProvider>().fetchReviews(
        widget.vendorId,
        isLoadMore: true,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReviewsProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: const CustomAppBar(title: "Reviews"),
            ),
            Expanded(
              child: provider.isLoading
                  ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.primary,
                        size: 40,
                      ),
                    )
                  : provider.reviews.isEmpty
                  ? Center(
                      child: Text(
                        "No reviews found",
                        style: AppFontStyle.text_16_600(AppColors.black),
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      itemCount:
                          provider.reviews.length +
                          (provider.isLoadMore ? 1 : 0),
                      separatorBuilder: (context, index) => hBox(16.h),
                      itemBuilder: (context, index) {
                        if (index < provider.reviews.length) {
                          return _buildReviewCard(provider.reviews[index]);
                        } else {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: AppColors.primary,
                                size: 30,
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Data review) {
    final userName =
        "${review.user?.firstName ?? ''} ${review.user?.lastName ?? ''}".trim();
    final userImage = ImagePathHelper.getFullImageUrl(
      review.user?.proImg,
      AppUrls.imageBaseUrl,
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundImage: userImage.isNotEmpty
                    ? CachedNetworkImageProvider(userImage)
                    : null,
                backgroundColor: AppColors.lightGrey,
                child: userImage.isEmpty
                    ? Icon(Icons.person, color: AppColors.white, size: 30.r)
                    : null,
              ),
              wBox(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : "Unknown User",
                          style: AppFontStyle.text_16_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.semiBold,
                          ),
                        ),
                        Text(
                          Get.timeAgo(review.createdAt),
                          style: AppFontStyle.text_12_400(AppColors.lightGrey3),
                        ),
                      ],
                    ),
                    hBox(4.h),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (review.rating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          size: 16.w,
                          color: index < (review.rating ?? 0)
                              ? AppColors.orange
                              : AppColors.lightGrey3,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          hBox(12.h),
          Text(
            review.review ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppFontStyle.text_14_400(
              AppColors.lightGrey3,
              fontFamily: AppFontFamily.regular,
            ),
          ),
        ],
      ),
    );
  }
}

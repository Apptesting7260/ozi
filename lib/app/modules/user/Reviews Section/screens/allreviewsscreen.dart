import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../provider/reviewsprovider.dart';
import '../model/reviewmodel.dart';

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewsProvider(),
      child: const AllReviewsView(),
    );
  }
}

class AllReviewsView extends StatelessWidget {
  const AllReviewsView({super.key});

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
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      itemCount: provider.reviews.length,
                      separatorBuilder: (context, index) => hBox(16.h),
                      itemBuilder: (context, index) {
                        return _buildReviewCard(provider.reviews[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
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
                backgroundImage: CachedNetworkImageProvider(review.userImage),
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
                          review.userName,
                          style: AppFontStyle.text_16_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.semiBold,
                          ),
                        ),
                        Text(
                          review.date,
                          style: AppFontStyle.text_12_400(AppColors.lightGrey3),
                        ),
                      ],
                    ),
                    hBox(4.h),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          size: 16.w,
                          color: index < review.rating.floor()
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
            review.reviewText,
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

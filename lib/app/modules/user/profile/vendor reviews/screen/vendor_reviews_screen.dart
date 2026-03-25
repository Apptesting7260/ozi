import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_image_path_helper.dart';
import '../model/vendor_review_model.dart';
import '../provider/vendor_review_provider.dart';

class VendorReviewsScreen extends StatefulWidget {

  const VendorReviewsScreen({super.key});

  @override
  State<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends State<VendorReviewsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VendorReviewProvider>().fetchReviews();
    });
  }


  @override
  Widget build(BuildContext context) {

    final provider = context.watch<VendorReviewProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child:provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const CustomAppBar(title: "Reviews"),
            _ratingSummary(provider),
            const SizedBox(height: 1),
            _filterChips(provider),
            const SizedBox(height: 20),
            Expanded(child: _reviewsList(provider)),
          ],
        ),
      ),
    );
  }

  Widget _ratingSummary(VendorReviewProvider provider) {
    final reviews = provider.reviewsData?.data?.reviewDetails ?? [];

    int total = reviews.length;

    int count5 = reviews.where((e) => e.rating == 5).length;
    int count4 = reviews.where((e) => e.rating == 4).length;
    int count3 = reviews.where((e) => e.rating == 3).length;
    int count2 = reviews.where((e) => e.rating == 2).length;
    int count1 = reviews.where((e) => e.rating == 1).length;

    double percent(int count) => total == 0 ? 0 : count / total;

    final avgRating =
        double.tryParse(provider.reviewsData?.data?.averageRating ?? "0") ?? 0.0;

    return Padding(
      padding:  EdgeInsets.all(14.w),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: AppFontStyle.text_30_600(AppColors.darkText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Based on $total reviews",
                    style: AppFontStyle.text_12_400(AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _ratingBar(5, percent(count5)),
                    _ratingBar(4, percent(count4)),
                    _ratingBar(3, percent(count3)),
                    _ratingBar(2, percent(count2)),
                    _ratingBar(1, percent(count1)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Row(
            children: List.generate(
              star,
                  (index) => const Icon(Icons.star, size: 16, color: Color.fromRGBO(248, 189, 0, 1),),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(248, 189, 0, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text("${(value * 100).toStringAsFixed(1)}%",
            style: AppFontStyle.text_12_400(
              Color.fromRGBO(28, 29, 33, 1),
             // fontFamily: AppFontFamily.semiBold,
            ),
    ),
        ],
      ),
    );
  }

  Widget _filterChips(VendorReviewProvider provider) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: provider.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = provider.selectedFilterIndex == index;

          return GestureDetector(
            onTap: () {
              provider.setFilter(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(19, 172, 111, 1)
                    : const Color(0xffEDEDED),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                provider.filters[index],
                style: AppFontStyle.text_12_400(
                  isSelected ? Colors.white : const Color.fromRGBO(112, 108, 108, 1),
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _reviewsList(VendorReviewProvider provider) {
    final reviews = provider.filteredReviews;

    if (reviews.isEmpty) {
      return const Center(child: Text("No Reviews Found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(reviews[index]);
      },
    );
  }

  Widget _buildReviewCard(ReviewDetails review) {
    final userName =
    "${review.user?.firstName ?? ''} ${review.user?.lastName ?? ''}".trim();
    final userImage = ImagePathHelper.getFullImageUrl(
      review.user?.proImg,
      AppUrls.imageBaseUrl,
    );

    return Container(
      padding: EdgeInsets.all(14.w),
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
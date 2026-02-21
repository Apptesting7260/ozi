import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/modules/user/singleService/provider/singlesrviceprovider.dart';
import 'package:ozi/app/modules/user/singleService/model/singleservicemodel.dart'
    as model;
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:ozi/app/shared/widgets/read_more_text.dart';
import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/modules/user/home/model/category_model.dart';
import 'package:ozi/app/modules/user/home/service%20details/view/vendordetailscreen.dart';
import 'package:ozi/app/modules/user/navigation%20tab/view/navigation_tab_screen.dart';

class singleServiceScreen extends StatefulWidget {
  final int serviceId;
  final bool isCart;
  const singleServiceScreen({
    super.key,
    required this.serviceId,
    required this.isCart,
  });

  @override
  State<singleServiceScreen> createState() => _singleServiceScreenState();
}

class _singleServiceScreenState extends State<singleServiceScreen> {
  late SingleServiceProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = SingleServiceProvider(Repository());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getSingleService(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<SingleServiceProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(
              onBackTap: () => Navigator.pop(context, true),
              // maxLines: 2,
              // TextOverflow: TextOverflow.ellipsis,
              title: "Service Details",
              // provider.serviceData?.data?.serviceName ?? "Service Details",
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : provider.error != null
                        ? Center(child: Text(provider.error!))
                        : provider.serviceData?.data == null
                        ? const Center(child: Text("No data found"))
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(16.w),
                            child: _buildServiceCard(
                              context,
                              provider.serviceData!.data!,
                              provider,
                            ),
                          ),
                  ),
                  if (!provider.isLoading && provider.cartItemCount > 0) ...[
                    Divider(color: AppColors.containerBorder, thickness: 1),
                    _buildBottomBar(context, provider),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, SingleServiceProvider provider) {
    return widget.isCart
        ? Container(
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${provider.totalAmount.toStringAsFixed(2)}',
                  style: AppFontStyle.text_28_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.bold,
                  ),
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const NavigationTabScreen(initialIndex: 1),
                      ),
                    );
                  },
                  width: 150.w,
                  height: 50.h,
                  color: AppColors.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(
                        path: ImageConstants.cart,
                        height: 20.w,
                        width: 20.w,
                        color: AppColors.white,
                      ),
                      wBox(8),
                      Text(
                        'View Cart',
                        style: AppFontStyle.text_14_600(
                          Colors.white,
                          fontFamily: AppFontFamily.semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    return "${AppUrls.imageBaseUrl}$path";
  }

  Widget _buildServiceCard(
    BuildContext context,
    model.Data serviceData,
    SingleServiceProvider provider,
  ) {
    final vendorName =
        '${serviceData.vendor?.firstName ?? ""} ${serviceData.vendor?.lastName ?? ""}'
            .trim();
    final serviceType = serviceData.category?.categoryName ?? 'Services';
    final duration =
        '${serviceData.durationValue ?? 0} ${serviceData.durationType ?? 'Hours'}';
    final price = (serviceData.servicePrice ?? 0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vendor Header
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.lightGrey2,
              backgroundImage: serviceData.vendor?.proImg != null
                  ? CachedNetworkImageProvider(
                      getFullImageUrl(serviceData.vendor?.proImg),
                    )
                  : null,
              child: serviceData.vendor?.proImg == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            wBox(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendorName.isEmpty ? 'Unknown Provider' : vendorName,
                    style: AppFontStyle.text_16_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14.sp, color: AppColors.orange),
                      wBox(4),
                      Text(
                        "${serviceData.avgRating ?? 0.0}", // Placeholder as model doesn't have ratings
                        style: AppFontStyle.text_12_600(
                          AppColors.black,
                          fontFamily: AppFontFamily.bold,
                        ),
                      ),
                      wBox(4),
                      Text(
                        '• $serviceType',
                        style: AppFontStyle.text_12_400(AppColors.lightGrey3),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            widget.isCart == true
                ? _buildViewButton(context, serviceData)
                : SizedBox.shrink(),
          ],
        ),
        hBox(16),
        // Service Details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: getFullImageUrl(serviceData.serviceImage),
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 100.w,
                  height: 100.w,
                  color: AppColors.lightGrey2,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 100.w,
                  height: 100.w,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            wBox(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceData.serviceName ?? 'Service',
                    style: AppFontStyle.text_16_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  hBox(4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: AppColors.lightGrey3,
                      ),
                      wBox(4),
                      Text(
                        duration,
                        style: AppFontStyle.text_12_400(AppColors.lightGrey3),
                      ),
                    ],
                  ),
                  hBox(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: AppFontStyle.text_18_600(
                          AppColors.primary,
                          fontFamily: AppFontFamily.bold,
                        ),
                      ),
                      widget.isCart == true
                          ? provider.isInCart(serviceData.id ?? 0)
                                ? _buildCounter(
                                    serviceData.id ?? 0,
                                    provider,
                                    context,
                                  )
                                : _buildAddButton(
                                    serviceData.id ?? 0,
                                    provider,
                                    context,
                                  )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        hBox(16),
        // Description
        ReadMoreDescription(
          text: serviceData.description ?? '',
          style: AppFontStyle.text_13_400(AppColors.lightGrey3),
          trimLines: 2,
        ),
      ],
    );
  }

  Widget _buildViewButton(BuildContext context, model.Data serviceData) {
    return InkWell(
      onTap: () {
        if (serviceData.vendorId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailScreen(
                vendorId: serviceData.vendorId.toString(),
                vendorName:
                    "${serviceData.vendor?.firstName ?? ""} ${serviceData.vendor?.lastName ?? ""}",
                service: Subcategories(
                  id: serviceData.subcategoryId ?? serviceData.categoryId,
                  categoryName:
                      serviceData.subcategory?.categoryName ??
                      serviceData.category?.categoryName,
                ),
                categoryId: serviceData.categoryId ?? 0,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'View',
          style: AppFontStyle.text_12_600(
            AppColors.primary,
            fontFamily: AppFontFamily.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
    int serviceId,
    SingleServiceProvider provider,
    BuildContext context,
  ) {
    return CustomButton(
      width: 80.w,
      height: 35.h,
      borderRadius: BorderRadius.circular(20.r),
      color: AppColors.primary,
      onPressed: () async {
        try {
          await provider.addToCart(serviceId);
        } catch (e) {
          _showErrorDialog(context, e.toString());
        }
      },
      text: "Add",
      textStyle: AppFontStyle.text_14_600(
        Colors.white,
        fontFamily: AppFontFamily.bold,
      ),
    );
  }

  Widget _buildCounter(
    int serviceId,
    SingleServiceProvider provider,
    BuildContext context,
  ) {
    final quantity = provider.getQuantity(serviceId);

    return Container(
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              try {
                await provider.decrementQuantity(serviceId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to update quantity'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.remove, size: 16.sp, color: AppColors.primary),
            ),
          ),
          wBox(8),
          Text(
            '$quantity',
            style: AppFontStyle.text_14_600(
              AppColors.primary,
              fontFamily: AppFontFamily.bold,
            ),
          ),
          wBox(8),
          GestureDetector(
            onTap: () async {
              try {
                await provider.incrementQuantity(serviceId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to update quantity'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.add, size: 16.sp, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              wBox(10),
              Text(
                "Error",
                style: AppFontStyle.text_18_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppFontStyle.text_14_400(AppColors.darkText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: AppFontStyle.text_14_600(
                  AppColors.grey,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),
            CustomButton(
              width: 100.w,
              height: 35.h,
              text: "View Cart",
              color: AppColors.primary,
              textStyle: AppFontStyle.text_12_600(
                Colors.white,
                fontFamily: AppFontFamily.semiBold,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigationTabScreen(initialIndex: 1),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

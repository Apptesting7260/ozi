import 'package:ozi/app/modules/user/home/model/category_model.dart';
import 'package:ozi/app/modules/user/navigation%20tab/view/navigation_tab_screen.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/ServiceDetailProvider.dart';
import '../model/ServiceDetailsModel.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Subcategories service;
  final int categoryId;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailProvider(service, categoryId),
      child: ServiceDetailView(service: service),
    );
  }
}

class ServiceDetailView extends StatelessWidget {
  final Subcategories service;
  const ServiceDetailView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceDetailProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomAppBar(
                  title: service.categoryName ?? 'Service Details'),
            ),
            Expanded(
              child: _buildBody(provider),
            ),
            if (!provider.isLoading && provider.cartItemCount > 0) ...[
              Divider(color: AppColors.dividerColor),
              _buildBottomBar(context, provider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ServiceDetailProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.grey),
              hBox(16),
              Text(
                provider.errorMessage!,
                style: AppFontStyle.text_16_400(Colors.grey),
                textAlign: TextAlign.center,
              ),
              hBox(16),
              CustomButton(
                onPressed: provider.refresh,
                text: 'Retry',
                width: 120,
                height: 45,
                color: AppColors.primary,
                textStyle: AppFontStyle.text_14_600(
                  Colors.white,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.serviceProviders.isEmpty) {
      return Center(
        child: Text(
          'No services available',
          style: AppFontStyle.text_16_400(Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics:
        AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: provider.serviceProviders.length,
        itemBuilder: (context, index) {
          final serviceData = provider.serviceProviders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _buildServiceCard(context, serviceData, provider),
          );
        },
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Divider(
            thickness: 1,
            color: AppColors.containerBorder,
          ),
        ),
      ),
    );
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    return "${AppUrls.imageBaseUrl}$path";
  }


  Widget _buildServiceCard(
      BuildContext context,
      ServiceData serviceData,
      ServiceDetailProvider provider,
      ) {
    final duration =
        '${serviceData.durationValue ?? 0} ${serviceData.durationType ?? 'Hours'}';
    final price = (serviceData.servicePrice ?? 0).toDouble();

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: getFullImageUrl(serviceData.serviceImage),
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 110,
                    height: 110,
                    color: AppColors.lightGrey2,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              wBox(16),
              SizedBox(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.56,
                          child: Text(
                            serviceData.serviceName ?? 'Service',
                            style: AppFontStyle.text_16_600(
                              AppColors.black,
                              fontFamily: AppFontFamily.semiBold,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            wBox(4),
                            Text(
                              duration,
                              style: AppFontStyle.text_13_400(Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),


                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: AppFontStyle.text_20_600(
                              AppColors.primary,
                              fontFamily: AppFontFamily.bold,
                            ),
                          ),
                          provider.isInCart(serviceData.id ?? 0)
                              ? _buildCounter(serviceData.id ?? 0, provider)
                              : _buildAddButton(serviceData.id ?? 0, provider,context),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          hBox(16),
          Text(
            serviceData.description ?? '',
            style: AppFontStyle.text_13_400(Colors.grey[600]!),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(int serviceId, ServiceDetailProvider provider,BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: CustomButton(
        width: 100,
        height: 40,
        borderRadius: BorderRadius.circular(30),
        color: AppColors.primary,
        onPressed: () async {
          try {
            await provider.addToCart(serviceId);
            // Optionally show success message
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Added to cart successfully')),
            // );
          } catch (e) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add to cart'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        text: "Add",
        textStyle: AppFontStyle.text_14_600(
          Colors.white,
          fontFamily: AppFontFamily.bold,
        ),
      ),
    );
  }
  Widget _buildCounter(int serviceId, ServiceDetailProvider provider) {
    final quantity = provider.getQuantity(serviceId);

    return SizedBox(
      width: 100,
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => provider.decrementQuantity(serviceId),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.remove, size: 18, color: AppColors.primary),
              ),
            ),
            Text(
              '$quantity',
              style: AppFontStyle.text_16_600(
                AppColors.primary,
                fontFamily: AppFontFamily.bold,
              ),
            ),
            GestureDetector(
              onTap: () => provider.incrementQuantity(serviceId),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.add, size: 18, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, ServiceDetailProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
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
                  builder: (_) => NavigationTabScreen(initialIndex: 1),
                ),
              );
            },
            width: 150,
            height: 50,
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(
                  path: ImageConstants.cart,
                  height: 20,
                  width: 20,
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
    );
  }
}
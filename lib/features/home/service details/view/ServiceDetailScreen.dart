import 'package:cached_network_image/cached_network_image.dart';
import 'package:ozi/core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../provider/ServiceDetailProvider.dart';
import '../../services/provider/CategoryDetailProvider.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailProvider(service),
      child: ServiceDetailView(service: service),
    );
  }
}

class ServiceDetailView extends StatelessWidget {
  final Service service;
  const ServiceDetailView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceDetailProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(title: service.name),
          Expanded(
            child: ListView.builder(
              padding:  EdgeInsets.all(16),
              itemCount: provider.serviceProviders.length,
              itemBuilder: (context, index) {
                final serviceProvider = provider.serviceProviders[index];
                return _buildServiceCard(context, serviceProvider, provider);
              },
            ),
          ),

          _buildBottomBar(context, provider),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ServiceProvider serviceProvider,
    ServiceDetailProvider provider,
  ) {
    return Container(
      padding:  EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: serviceProvider.imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Service Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceProvider.title,
                      style: AppFontStyle.text_16_600(
                        AppColors.black,
                        fontFamily: AppFontFamily.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Left – Duration + Price column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  serviceProvider.duration,
                                  style: AppFontStyle.text_13_400(Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '\$${serviceProvider.price.toStringAsFixed(2)}',
                              style: AppFontStyle.text_20_600(
                                AppColors.primary,
                                fontFamily: AppFontFamily.bold,
                              ),
                            ),
                          ],
                        ),

                        // _buildAddButton(serviceProvider.id, provider),
                        const SizedBox(height: 12),
                        // Add Button or Counter
                        provider.isInCart(serviceProvider.id)
                            ? _buildCounter(serviceProvider.id, provider)
                            : _buildAddButton(serviceProvider.id, provider),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            serviceProvider.description,
            style: AppFontStyle.text_13_400(Colors.grey[600]!),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          hBox(20),

          Divider(thickness: 2),
        ],
      ),
    );
  }

  Widget _buildAddButton(String serviceId, ServiceDetailProvider provider) {
    return CustomButton(
      width: 110,
      height: 40,
      borderRadius: BorderRadius.circular(25),
      color: AppColors.primary,
      onPressed: () => provider.addToCart(serviceId),
      text: "Add",
      textStyle: AppFontStyle.text_14_600(
        Colors.white,
        fontFamily: AppFontFamily.bold,
      ),
    );
  }

  Widget _buildCounter(String serviceId, ServiceDetailProvider provider) {
    final quantity = provider.getQuantity(serviceId);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => provider.decrementQuantity(serviceId),
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.remove, size: 18, color: AppColors.primary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$quantity',
              style: AppFontStyle.text_16_600(
                AppColors.primary,
                fontFamily: AppFontFamily.bold,
              ),
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
    );
  }

  Widget _buildBottomBar(BuildContext context, ServiceDetailProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
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
            onPressed: () {},
            width: 150,
            height: 50,
            color: AppColors.primary,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(path: ImageConstants.cart, color: AppColors.white),
                 SizedBox(width: 8),
                Text(
                  'View Cart',
                  style: AppFontStyle.text_18_600(
                    Colors.white,
                    fontFamily: AppFontFamily.bold,
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

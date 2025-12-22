import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_radio_button.dart';
import '../provider/ChangeAddressProvider.dart';


class ChangeAddressScreen extends StatelessWidget {
  const ChangeAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangeAddressProvider(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [

            CustomAppBar(title: "Change Address"),

            Expanded(
              child: Consumer<ChangeAddressProvider>(
                builder: (context, provider, _) {
                  return ListView(
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    children: [

                      ...List.generate(
                        provider.addresses.length,
                            (index) {
                          final data = provider.addresses[index];
                          final isSelected = provider.selectedIndex == index;

                          return GestureDetector(
                            onTap: () => provider.selectCard(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.containerBorder,
                                ),
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.08)
                                    : AppColors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  _leftIcon(data.title),

                                  SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              data.title,
                                              style:
                                              AppFontStyle.text_16_700(
                                                  AppColors.black),
                                            ),

                                            if (data.label != null) ...[
                                              SizedBox(width: 6),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  data.label!,
                                                  style:
                                                  AppFontStyle.text_10_600(
                                                      AppColors.primary),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),

                                        SizedBox(height: 4),

                                        Text(
                                          data.address,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          AppFontStyle.text_13_400(
                                              AppColors.grey),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  CustomRadioButton(
                                    value: isSelected,
                                    onChanged: (_) =>
                                        provider.selectCard(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Center(
                              child: Text(
                                "+ Add New Address",
                                style: AppFontStyle.text_16_600(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                     hBox(50),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: REdgeInsets.all(16),
              child: CustomButton(
                text: "Continue",
                onPressed: () {},
                height: 50,
                borderRadius: BorderRadius.circular(60),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _leftIcon(String text) {

    if (text == "Home") {
      return _circleIcon(ImageConstants.home);
    }
    else if (text == "Work") {
      return _circleIcon(ImageConstants.work);
    }
    else if (text == "Other") {
      return _circleIcon(ImageConstants.location);
    }
    else {
      return CustomImage(path: ImageConstants.appLogo);
    }
  }
  Widget _circleIcon(String imagePath) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.3),
      ),
      padding: const EdgeInsets.all(10),
      child: CustomImage(path: imagePath),
    );
  }

}

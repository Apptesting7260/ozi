import 'package:image_picker/image_picker.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/set_availability.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/models/category_dropdown_model.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_dropdown.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/service details provider.dart';
import '../widget/vendor_custom_appbar.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailsProvider(),
      child: const _ServiceDetailsContent(),
    );
  }
}

class _ServiceDetailsContent extends StatelessWidget {
  const _ServiceDetailsContent();

  Future<void> _pickImage(BuildContext context) async {
    final provider =
    Provider.of<ServiceDetailsProvider>(context, listen: false);

    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      provider.setImage(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceDetailsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            VendorCustomAppBar(
              title: "Service Details",
              columnChild: Text(
                "Step 2 of 6",
                style: AppFontStyle.text_12_400(AppColors.grey),
              ),
            ),

            /// -------- SCROLLABLE CONTENT --------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    hBox(2),

                    // ================= IMAGE UPLOAD =================
                    GestureDetector(
                      onTap: () => _pickImage(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                                style: provider.pickedImage == null
                                    ? BorderStyle.solid
                                    : BorderStyle.none,
                              ),
                            ),
                            child: provider.pickedImage == null
                                ? Center(
                              child: CustomImage(
                                path: ImageConstants.uploadImage,
                                height: 20,
                                width: 20,
                                color: AppColors.lightGrey3,
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                provider.pickedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          wBox(14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload Service Image",
                                  style: AppFontStyle.text_14_600(
                                    AppColors.darkText,
                                    fontFamily: AppFontFamily.semiBold,
                                  ),
                                ),

                                hBox(4),

                                Text(
                                  "PNG, JPG up to 5MB",
                                  style: AppFontStyle.text_12_400(AppColors.grey),
                                ),

                                hBox(10),

                                CustomButton(
                                  height: 35,
                                  width: 150,
                                  borderRadius: BorderRadius.circular(30),
                                  onPressed: () => _pickImage(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomImage(
                                        path: ImageConstants.uploadImage,
                                        height: 16,
                                        width: 16,
                                        color: AppColors.white,
                                      ),
                                      wBox(5),
                                      Text(
                                        provider.pickedImage == null
                                            ? "Upload Image"
                                            : "Change Image",
                                        style: AppFontStyle.text_12_400(
                                          AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    hBox(28),

                    CustomTextFormField(
                      label: "Service Name",
                      hintText: "e.g. Deep House Cleaning",
                      borderRadius: 60,
                      onChanged: provider.setName,
                    ),

                    hBox(20),

                    CustomDropDownT<CategoryDropDownData>(
                      label: "Category",
                      items: provider.categories?.data??[],
                      selectedValue: provider.category,
                      hintText: "Select category",
                      onChanged: provider.setCategory,
                      validator: (_) => null,
                      borderRadius: 60,
                    ),

                    hBox(20),

                    CustomDropDownT<Subcategories>(
                      label: "Sub Category",
                      items: provider.category?.subcategories??[],
                      selectedValue: provider.subCategory,
                      hintText: "Select sub category",
                      onChanged: provider.setSubCategory,
                      validator: (_) => null,
                      borderRadius: 60,
                    ),

                    hBox(20),

                    CustomTextFormField(
                      label: "Description",
                      hintText: "Describe your service in detail...",
                      maxLines: 5,
                      minLines: 5,
                      borderRadius: 30,
                      onChanged: provider.setDescription,
                    ),

                    hBox(20),

                    CustomTextFormField(
                      label: "Service Price",
                      hintText: "0.00",
                      textInputType: TextInputType.number,
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: CustomImage(
                          path: ImageConstants.dollar,
                          height: 16,
                          width: 16,
                        ),
                      ),
                      borderRadius: 60,
                      onChanged: provider.setPrice,
                    ),

                    hBox(20),

                    Text(
                      "Estimated Duration",
                      style: AppFontStyle.text_14_500(AppColors.darkText),
                    ),

                    hBox(8),

                    Row(
                      children: [
                        Expanded(
                          child: CustomDropDown(
                            items: const ["1", "2", "3", "4"],
                            selectedValue: provider.durationValue,
                            hintText: "0",
                            onChanged: provider.setDurationValue,
                            validator: (_) => null,
                            borderRadius: 60,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomDropDown(
                            items: const ["minutes", "hours"],
                            selectedValue: provider.durationUnit,
                            hintText: "Minutes",
                            onChanged: provider.setDurationUnit,
                            validator: (_) => null,
                            borderRadius: 60,
                          ),
                        ),
                      ],
                    ),

                    hBox(28),

                    CustomButton(
                      text: "Continue",
                      height: 54,
                      borderRadius: BorderRadius.circular(60),
                      isLoading: provider.addLoading,
                      onPressed: () {
                        provider.addNewService();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => SetAvailabilityScreen(),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

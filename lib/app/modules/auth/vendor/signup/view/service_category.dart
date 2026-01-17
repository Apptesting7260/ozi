import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/response/api_status.dart';
import '../provider/ServiceCategoryProvider.dart';
import '../widget/vendor_custom_appbar.dart';

class ServiceCategory extends StatelessWidget {
   ServiceCategory({super.key});



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceCategoryProvider(),
      child: Consumer<ServiceCategoryProvider>(builder: (context, value, child) {
        return Scaffold(
          bottomNavigationBar: _bottomButton(context),
          body: SafeArea(
            child: switch (value.categoriesModel.status) {
              ApiStatus.loading =>
              const Center(child: CircularProgressIndicator()),

              ApiStatus.completed =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      VendorCustomAppBar(
                        title: "Select Service Categories",
                        columnChild: Text(
                          "Step 1 of 6",
                          style: AppFontStyle.text_12_400(AppColors.grey),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hBox(18),
                              Text(
                                "Choose the services you want to offer. You can select multiple categories.",
                                style: AppFontStyle.text_14_400(AppColors.grey),
                              ),
                              hBox(18),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: value.categoriesModel?.data?.data?.length??0,
                                  itemBuilder: (_, index) {
                                    return _categoryItem(
                                      context: context,
                                      title: value.categoriesModel?.data?.data?[index].categoryName??'',
                                      catId: value.categoriesModel?.data?.data?[index].id??'',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

              ApiStatus.error =>
              const Center(child: Text('Something went wrong')),

              _ =>
              const SizedBox.shrink(),
            },
          ),
        );
      },)
    );
  }



   // ---------------- CATEGORY ITEM ----------------
   Widget _categoryItem({
     required BuildContext context,
     required String title,
     required String catId
   }) {
     return Consumer<ServiceCategoryProvider>(
       builder: (context, provider, _) {
         final selected = provider.isSelected(catId);

         return GestureDetector(
           onTap: () => provider.toggleCategory(catId),
           child: Container(
             height: 55,
             margin: const EdgeInsets.only(bottom: 12),
             decoration: BoxDecoration(
               color: selected
                   ? AppColors.primary.withOpacity(0.08)
                   : AppColors.white,
               borderRadius: BorderRadius.circular(40),
               border: Border.all(
                 color: selected
                     ? AppColors.primary
                     : AppColors.primary.withOpacity(0.3),
                 width: 1.3,
               ),
             ),
             alignment: Alignment.center,
             child: Text(
               title,
               style: AppFontStyle.text_15_500(
                 AppColors.darkText,
                 fontFamily: AppFontFamily.medium,
               ),
             ),
           ),
         );
       },
     );
   }

   // ---------------- BOTTOM BUTTON ----------------
   Widget _bottomButton(BuildContext context) {
     return Consumer<ServiceCategoryProvider>(
       builder: (context, provider, _) {
         final count = provider.selected.length;

         return Padding(
           padding: const EdgeInsets.all(20),
           child: CustomButton(
             isLoading: provider.submitLoading,
             text: "Continue ($count selected)",
             color: count > 0
                 ? AppColors.primary
                 : AppColors.primary.withValues(alpha: 0.7),

             onPressed:provider.submitLoading?(){}: () {
               if (count == 0) return;
               provider.saveCategorites();
             },
           ),
         );
       },
     );
   }

}

// class _SelectServiceCategoriesContent extends StatelessWidget {
//   const _SelectServiceCategoriesContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return ;
//   }
//
//
// }

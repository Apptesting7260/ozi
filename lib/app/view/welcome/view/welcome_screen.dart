

import '../../../core/appExports/app_export.dart';
import '../../auth/login/view/login_screen.dart';
import '../provider/welcome_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeProvider(),
      child: const WelcomeScreenContent(),
    );
  }
}

class WelcomeScreenContent extends StatelessWidget {
  const WelcomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WelcomeProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: provider.pageController,
            onPageChanged: provider.onPageChanged,
            itemCount: provider.slides.length,
            itemBuilder: (context, index) {
              return CustomImage(
                path: provider.slides[index].imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  if (provider.currentPage > 0) {
                    provider.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
                else if (details.primaryVelocity! < 0) {
                  if (provider.currentPage < provider.slides.length - 1) {
                    provider.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.only(top:25, bottom: 30),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      provider.slides[provider.currentPage].heading,
                      style: AppFontStyle.text_22_600(
                        AppColors.black,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                    hBox(10),
                    SizedBox(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          provider.slides[provider.currentPage].subheading,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          style: AppFontStyle.text_16_400(AppColors.grey),
                        ),
                      ),
                    ),
                    hBox(50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        provider.slides.length,
                            (index) => Container(
                          margin:  EdgeInsets.symmetric(horizontal: 4),
                          width: provider.currentPage == index?24:8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: provider.currentPage == index
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      ),
                    ),


                    hBox(35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomButton(
                        onPressed: () {
                          if (provider.currentPage == provider.slides.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(),
                              ),
                            );
                          } else {
                            provider.nextPage();
                          }
                        },
                        text: provider.currentPage == provider.slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

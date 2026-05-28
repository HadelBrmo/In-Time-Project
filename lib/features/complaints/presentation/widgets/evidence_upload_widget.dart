import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class EvidenceUploadWidget
    extends StatelessWidget {

  const EvidenceUploadWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 30,
      ),

      decoration: BoxDecoration(

        border: Border.all(
          color: AppColors.greyColor,
        ),
      ),

      child: Row(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    Expanded(

      child: Container(

        height: 60,

        decoration: BoxDecoration(

          color:
              AppColors.primaryColor,

          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Material(

          color: Colors.transparent,

          child: InkWell(

            borderRadius:
                BorderRadius.circular(
                    18),

            onTap: () {

              /// upload image
            },

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Icon(

                  Icons.image_outlined,

                  color: AppColors.whiteColor,
                ),

                const SizedBox(width: 10),

                const Text(

                  'صورة',

                  style: TextStyle(

                    color: AppColors.whiteColor,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 20),

    Expanded(

      child: Container(

        height: 60,

        decoration: BoxDecoration(

          color:
              AppColors.primaryColor,

          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Material(

          color: Colors.transparent,

          child: InkWell(

            borderRadius:
                BorderRadius.circular(
                    18),

            onTap: () {

              /// upload file
            },

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Icon(

                  Icons.folder_open_outlined,

                  color:AppColors.whiteColor,
                ),

                const SizedBox(width: 10),

                const Text(

                  'ملف',

                  style: TextStyle(

                    color: AppColors.whiteColor,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
),
    );
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ComplaintSuccessDialog {

  static void show(
      BuildContext context) {

    showGeneralDialog(

      context: context,

      barrierDismissible: true,

      barrierLabel: '',

      pageBuilder:
          (_, __, ___) {

        return BackdropFilter(

          filter: ImageFilter.blur(

            sigmaX: 4,

            sigmaY: 4,
          ),

          child: Material(

            color: Colors.transparent,

            child: Center(

              child: Container(

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 28,
                ),

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 30,

                  vertical: 40,
                ),

                decoration: BoxDecoration(

                  color:AppColors.whiteColor,

                  borderRadius:
                      BorderRadius.circular(40),

                  boxShadow: [

                    BoxShadow(

                      color:
                          AppColors.blackColor,

                      blurRadius: 20,
                    ),
                  ],
                ),

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    Container(

                      width: 130,

                      height: 130,

                      decoration:
                          const BoxDecoration(

                        color:
                            AppColors.yellowColor,

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(

                        Icons.check,

                        color: AppColors.whiteColor,

                        size: 90,
                      ),
                    ),

                    const SizedBox(
                        height: 28),

                    const Text(

                      'تم إرسال شكوتك بنجاح',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color: AppColors.blackColor,

                        fontSize: 20,

                        fontWeight:
                           FontWeight.w500,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    const Text(
                      'سيتم مراجعة شكوتك من قبل الإدارة',
                      style: TextStyle(
                        color: AppColors.blackColor,

                        fontSize: 20,

                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    const SizedBox(
                        height: 35),

                    SizedBox(

                      width: 220,

                      height: 65,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              AppColors
                                  .primaryColor,

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        18),
                          ),
                        ),

                        onPressed: () {

                          Navigator.pop(
                              context);
                        },

                        child: const Text(

                          'تم',

                          style: TextStyle(

                            color:AppColors.whiteColor,

                            fontSize: 25,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }}
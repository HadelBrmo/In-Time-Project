import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../widgets/signup_widgets/buildHeaderForSignUp.dart';
import '../../widgets/signup_widgets/buildNote.dart';

class SignUpPage3 extends StatefulWidget {
  const SignUpPage3({super.key});

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  String? selectedDocument;
  File? documentImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        documentImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildHeaderForSignUp(media, context, subTitle: "التحقق من الهوية"),
            Container(
              margin: EdgeInsets.only(top: media.height * 0.19, right: 10, left: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Icon(Icons.badge_outlined, size: 100, color: AppColors.primaryColor.withOpacity(0.6)),
                      const Text(
                        "قم برفع صورة واحدة واضحة لأحد المستندات الآتية",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Text(
                        "الهوية الشخصية - جواز السفر - رخصة القيادة",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 30),
                      buildLabel("نوع الوثيقة"),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            iconEnabledColor: AppColors.primaryColor,
                            value: selectedDocument,
                            hint: const Text("اختر نوع الوثيقة",style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 14,
                            ),),
                            style: TextStyle(color: AppColors.greyColor),
                            isExpanded: true,
                            items: ["هوية شخصية", "جواز سفر", "رخصة قيادة"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => selectedDocument = val),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: const Radius.circular(15),
                            color: AppColors.primaryColor.withOpacity(0.5),
                            strokeWidth: 2,
                            dashPattern: const [8, 4],
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            color: Colors.grey[50],
                            child: documentImage != null
                                ? Image.file(documentImage!, fit: BoxFit.cover)
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: AppColors.primaryColor, size: 40),
                                const Text("اضغط لرفع صورة الوثيقة",
                                    style: TextStyle(color: AppColors.primaryColor)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildNote("تأكد أن الصورة واضحة"),
                      buildNote("يجب أن تكون جميع المعلومات ظاهرة"),

                      const SizedBox(height: 30),
                      CustomButton(
                        text: "إرسال للتحقق",
                        width: media.width * 0.7,
                        onPressed: () {
                        Navigator.pushNamed(context, "/homeScreen");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
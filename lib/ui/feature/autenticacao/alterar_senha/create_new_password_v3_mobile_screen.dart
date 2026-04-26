import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_text_form_field.dart';

class CreateNewPasswordV3MobileScreen extends StatelessWidget {
  const CreateNewPasswordV3MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStyleSecondinaryDark900,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 24),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/pos_logo.png',
                          height: 34,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Create new password',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Let\'s create a new and more secure password',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryLight400,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          CustomTextFormField(
                            labelText: 'New Password',
                            autofillHints: [AutofillHints.password],
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'Repeat Password',
                            autofillHints: [AutofillHints.password],
                          ),
                          SizedBox(height: 24),
                          CustomButton(
                            label: 'Continue',
                            options: CustomButtonOptions(
                              color:
                                  kColorStylePrimaryNeutralPaletteDarkDefault,
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                24,
                                0,
                                24,
                                0,
                              ),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0,
                                0,
                                0,
                                0,
                              ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: kColorStylePrimaryNeutralPaletteDark600,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              textStyle: kTestStyleBoldText16.copyWith(
                                color:
                                    kColorStylePrimaryNeutralPaletteLightDefault,
                              ),
                            ),
                            onPressed: () {
                              context.go('/login/reset-password-success');
                            },
                          ),
                          SizedBox(height: 24),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  '© 2023 Posive. All rights reserved.',
                                  style: kTestStyleMediumText14.copyWith(
                                    color: kColorStyleSecondinaryLight400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Term & Condition',
                                style: kTestStyleBoldText14.copyWith(
                                  color: kColorStyleInformationDarkDefault,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: kColorStyleSecondinaryLight400,
                                  width: 1,
                                  height: 15,
                                  child: SizedBox(height: 10),
                                ),
                              ),
                              Text(
                                'Privacy & Policy',
                                style: kTestStyleBoldText14.copyWith(
                                  color: kColorStyleInformationDarkDefault,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    Image.asset('assets/images/pos_login_v3_tablet_left.png'),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Unleash the Power of Our Intuitive Point of Sale Solution',
                                  style: kTestStyleBoldText24.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Experience the future of retail with our user-friendly POS platform. Increase your sales, streamline operations, and delight your customers with a modern and efficient checkout process',
                                  style: kTestStyleRegularText14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

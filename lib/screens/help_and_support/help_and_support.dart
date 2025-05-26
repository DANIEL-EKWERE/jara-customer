import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:jara_market/widgets/custom_text_field.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.chevron_left_rounded),
          title: Text('Help and Support'),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Call or Chat with us and we will answer your questions',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          SvgPicture.asset('assets/images/phone.svg'),
                          Text(
                            'www.jaramarket.com.ng',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          SvgPicture.asset('assets/images/phone.svg'),
                          Text(
                            '+2347123456789',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          SvgPicture.asset('assets/images/help_support.svg'),
                          Text(
                            'hello@jaramarket.com',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          SvgPicture.asset('assets/images/office.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Corporate Office',
                                  style: TextStyle(
                                      color: Color(0xff3D3D3D),
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              Text('#12 Your address, LGA\nState, Nigeria',
                                  style: TextStyle(
                                      color: Color(0xff3D3D3D),
                                      fontFamily: 'Roboto',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          // RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(
                          //         text: '#12 Your address, LGA\nState, Nigeria',

                          //         style: TextStyle(
                          //           color: Color(0xff3D3D3D),
                          //           fontFamily: 'Roboto',
                          //           fontSize: 10,
                          //           fontWeight: FontWeight.w600
                          //           //decoration: TextDecoration.underline,
                          //         ),
                          //       ),
                          //     ],
                          //     text: '\nCorporate Office',
                          //     //style: DefaultTextStyle.of(context).style,
                          //     style: TextStyle(color: Color(0xff3D3D3D),
                          //           fontFamily: 'Roboto',
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600)
                          //   ),
                          // ),
                        ],
                      ),
                      // Spacer(),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                              width: 77.65,
                              height: 20,
                              child:
                                  //CustomButton(text: 'Get Direcition', onPressed: (){})
                                  ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Get Direction',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFECC2B),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      // Spacer(),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/map.png'),
                          fit: BoxFit.cover
                          ),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            //topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            //bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get In Touch.',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color(0xffF24A00)),
                      ),
                      Text('Chat with our customer care representative',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              fontSize: 10,
                              color: Color(0xff3D3D3D))),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(hint: 'Name'),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(child: CustomTextField(hint: 'Number')),
                          Expanded(child: CustomTextField(hint: 'Email')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Your Message',
                            hintStyle: TextStyle(color: Colors.black12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black12),
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 77.65,
                            height: 30,
                            child:
                                //CustomButton(text: 'Get Direcition', onPressed: (){})
                                ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Send',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFECC2B),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )),

                      ),
                      SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          SvgPicture.asset('assets/images/faq.svg'),Text('FAQ')
                        ],),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SvgPicture.asset('assets/images/facebook.svg'),
                        SvgPicture.asset('assets/images/instagram.svg'),
                        SvgPicture.asset('assets/images/x.svg'),
                        SvgPicture.asset('assets/images/telegram.svg'),
                        SvgPicture.asset('assets/images/linkedin.svg'),
                        SvgPicture.asset('assets/images/whatsApp.svg'),
                      ],),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

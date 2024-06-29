/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/utils.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../widgets/nav_drawer.dart';
import '../widgets/shared.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<StatefulWidget> createState() => LegalScreenState();
}

class LegalScreenState extends State<LegalScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: displayWidth(context),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    decoration: BoxDecoration(
                      color: ColorsUI.primaryColor.withOpacity(0.4),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Colors.black, size: 16),
                              ),
                            ),
                          ),
                          const Text(
                            "Privacy Policy",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                  Positioned(
                    top: -25,
                    right: 40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(75, 255, 255, 255),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    left: 70,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(75, 255, 255, 255),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              DesignWidgets.addVerticalSpace(16.0),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Introduction",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'Click Clinician Inc ("Click Clinician" or "We") respects your privacy and is committed to protecting it through our compliance with this policy. This policy describes: (a) the types of information we may collect or that you may provide when you purchase, download, install, register with, access, or use the Snap Health Platform (the "Platform"); and (b) our practices for collecting, using, maintaining, protecting, and disclosing that information.'),
                    DesignWidgets.getParagraph(
                        text:
                            'This policy applies only to information we (or our authorized representatives and contractors) collect in this Platform and in email, text, and other electronic communications sent through or in connection with this Platform. This policy DOES NOT apply to information that: (a) we (or our authorized representatives) collect offline or on any other Click Clinician platforms, apps or websites, including websites you may access through this Platform; or (b) you provide to or is collected by any third party. Our platforms, websites and apps, and these third parties may have their own privacy policies, which we encourage you to read before providing information on or through them.'),
                    DesignWidgets.getParagraph(
                        text:
                            'Please read this policy carefully to understand our policies and practices regarding your information and how we will treat it. If you do not agree with our policies and practices, do not download, register with, or use this Platform. By downloading, registering with, or using this Platform, you agree to this privacy policy. This policy may change from time to time. Your continued use of this Platform after we make changes is deemed to be acceptance of those changes, so please check the policy periodically for updates.'),
                    Text(
                      "Persons Under the Age of 18",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'YOU MUST BE 18 YEARS OF AGE OR OLDER TO DOWNLOAD, REGISTER WITH OR USE THE PLATFORM. We do not knowingly collect personal information from persons under 18. If we learn we have collected or received personal information from a person under 18, we will delete that information.'),
                    Text(
                      "Information We Collect and How We Collect It",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'We collect information from and about users of our Platform directly from you when you provide it to us (or our authorized representatives) and automatically when you use the Platform.'),
                    Text(
                      "Information You Provide to Us (or our Authorized Representatives)",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'When you download, register with, or use this Platform, we (or our authorized representatives) may ask you to provide information: (a) by which you may be personally identified, such as name, postal address, email address, social security number (or a portion thereof), date of birth, telephone number, or any other information the Platform collects that is defined as personal or personally identifiable information under an applicable law ("personal information"); and (b) that is about you but individually does not identify you.'),
                    DesignWidgets.getParagraph(
                        text: 'This information includes:', padding: 12.0),
                    DesignWidgets.getList([
                      'Information that you provide by filling in forms in the Platform. This includes information provided at the time of registering to use the Platform and posting material. We may also ask you for information when you report a problem with the Platform.',
                      'Records and copies of your correspondence (including email addresses and phone numbers), if you contact us.',
                      'Your responses to surveys that we might ask you to complete for research purposes.',
                      'Financial information and details of transactions you carry out through the Platform and of the fulfillment of same. You may be required to provide financial information before using some or all of the Platform.',
                      'Your search queries on the Platform.'
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                        text:
                            'You may provide information to be published or displayed ("Posted") on public areas of the Platform and/or websites you access through the Platform (collectively, "User Contributions"). Your User Contributions are Posted and transmitted to others at your own risk. Although you may set certain privacy settings for such information by logging into your account profile, please be aware that no security measures are perfect or impenetrable. Additionally, we cannot control the actions of third parties with whom you may choose to share your User Contributions. Therefore, we cannot and do not guarantee that your User Contributions will not be viewed by unauthorized persons.'),
                    Text(
                      "Automatic Information Collection and Tracking",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'When you download, access, and use the Platform, it may use technology to collect:',
                        padding: 12.0),
                    DesignWidgets.getList([
                      'Usage Details. When you access and use the Platform, we may collect certain details of your access to and use of the Platform, including traffic data, location data, logs, and other communication data and the resources that you access and use on or through the Platform.',
                      "Device Information. We may collect information about your mobile device and internet connection, including the device's unique device identifier, IP address, operating system, browser type, mobile network information, and the device's telephone number.",
                      'Stored Information and Files. The Platform also may access metadata and other information associated with other files stored on your device. This may include, for example, photographs, audio and video clips, personal contacts, and address book information.',
                      'Location Information. This Platform may collect real-time information about the location of your device and other location and access characteristics.'
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                      text:
                          'If you do not want us to collect this information, do not download the Platform or delete it from your device. We also may use these technologies to collect information about your activities over time and across third-party websites, platforms, apps, or other online services (behavioral tracking).',
                    ),
                    Text(
                      "Information Collection and Tracking Technologies",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'The technologies we use for automatic information collection may include, without limitation:',
                        padding: 12.0),
                    DesignWidgets.getList([
                      'Cookies (or mobile cookies). A cookie is a small file placed on your smartphone. It may be possible to refuse to accept mobile cookies by activating the appropriate setting on your smartphone. However, if you select this setting you may be unable to access certain parts of our Platform.',
                      "Web Beacons. Pages of the Platform and our emails may contain small electronic files known as web beacons (also referred to as clear gifs, pixel tags, and single-pixel gifs) that permit Snap Health, for example, to count users who have visited those pages or opened an email and for other related platform statistics (for example, recording the popularity of certain platform content and verifying system and server integrity).",
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    Text(
                      "Third-Party Information Collection",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'When you use the Platform or its content, certain third parties may use information collection technologies to collect information about you or your device. These third parties may include advertisers, payment processers or conduits, payment gateways, central account management systems, third-party verification service provider systems, geolocation and geofencing service providers, ad networks, ad servers, analytics companies, your mobile device manufacturer, your mobile service provider, our affiliates and others. These third parties may use tracking technologies to collect information about you when you use this Platform. The information they collect may be associated with your personal information or they may collect information, including personal information, about your online activities over time and across different platforms, websites, apps, and other online services websites. They may use this information to provide you with interest-based (behavioral) advertising or other targeted content.'),
                    DesignWidgets.getParagraph(
                        text:
                            "We do not control these third parties' tracking technologies or how they may be used. If you have any questions about an advertisement or other targeted content, you should contact the responsible provider directly."),
                    Text(
                      "How We Use Your Information",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'We use information that we (or our authorized representatives) collect about you or that you provide to us (or our authorized representatives), including any personal information, to:',
                        padding: 12.0),
                    DesignWidgets.getList([
                      'Provide you with the Platform and its contents, and any other information, products or services that you request from us.'
                          'Fulfill any other purpose for which you provide it.',
                      'Carry out our obligations and enforce our rights arising from any contracts entered into between you and us, including for billing and collection, if applicable.',
                      'Notify you when Platform updates are available, and of changes to any products or services we offer or provide though it.',
                      'Confirm that you are accessing the Platform from an approved location.',
                      'Comply with any court order, law, or legal process, including to respond to any government or regulatory request.'
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                        text:
                            'The usage information we collect helps us to improve our Platform and to deliver a better and more personalized experience by enabling us to:',
                        padding: 12.0),
                    DesignWidgets.getList([
                      'Estimate our audience size and usage patterns.',
                      'Store information about your preferences, allowing us to customize our Platform according to your individual interests.',
                      'Speed up your searches.',
                      'Recognize you when you use the Platform.',
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                        text:
                            "We may also use your information to contact you about our own, our affiliates' and third parties' goods and services that may be of interest to you. We may use the information we collect to display advertisements to our advertisers' target audiences."),
                    Text(
                      "Disclosure of Your Information",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'We may disclose aggregated information about our users, and information that does not identify any individual or device, without restriction.'),
                    DesignWidgets.getParagraph(
                        text:
                            'In addition, we may disclose personal information that we (or our authorized representatives) collect or you provide:',
                        padding: 12.0),
                    DesignWidgets.getList([
                      'To our subsidiaries and affiliates.',
                      'To contractors, service providers, and other third parties we use to support our business.',
                      'To a buyer or other successor in the event of a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Click Clinician assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which personal information held by Snap Health about our Platform users is among the assets transferred.',
                      'To third parties to market their products or services to you.',
                      'To fulfill the purpose for which you provide it.',
                      'For any other purpose disclosed by us when you provide the information.',
                      'With your consent or otherwise consistent with this policy.',
                      'To comply with any court order, law, or legal process, including to respond to any government or regulatory request.',
                      'To enforce our rights arising from any contracts entered into between you and us, including the Platform End User License Agreement, and for billing and collection.',
                      'If we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Click Clinician, our customers or others. This includes exchanging information with other companies and organizations for the purposes of fraud protection and credit risk reduction.'
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                        text:
                            'Except as contemplated in this privacy policy, we will keep player account information confidential unless otherwise required by law.'),
                    Text(
                      "Your Choices About Collection, Use, and Disclosure of Your Information",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'We strive to provide you with choices regarding the personal information you provide to us and our authorized representatives. This section describes mechanisms we provide for you to control certain uses and disclosures of over your information.',
                        padding: 16.0),
                    DesignWidgets.getList([
                      'Tracking Technologies. You can set your browser to refuse all or some browser cookies, or to alert you when cookies are being sent. If you disable or refuse cookies or block the use of other tracking technologies, some parts of the Platform may then be inaccessible or not function properly.',
                      "Location Information. You can choose whether or not to allow the Platform to collect and use real-time information about your device's location through the device's privacy settings. If you block the use of location information, some parts of the Platform may then be inaccessible or not function properly.",
                    ]),
                    DesignWidgets.addVerticalSpace(32.0),
                    DesignWidgets.getParagraph(
                        text:
                            "We do not control third parties' collection or use of your information to serve interest-based advertising. However these third parties may provide you with ways to choose not to have your information collected or used in this way. You can opt out of receiving targeted ads from members of the Network Advertising Initiative ('NAI') on the NAI's website."),
                    DesignWidgets.getParagraph(
                        text:
                            'In addition, California residents and certain residents of other states may have additional personal information rights and choices. Please see Other Privacy Rights Based on Residency for more information.'),
                    Text(
                      "Accessing and Correcting Your Personal Information",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'You can review and change your personal information by logging into the Platform and visiting your account profile page. You may also contact us to request access to, correct, or delete any personal information that you have provided to us. We cannot delete your personal information except by also deleting your user account. We may not accommodate a request to change information if we believe the change would violate any law or legal requirement or cause the information to be incorrect.'),
                    DesignWidgets.getParagraph(
                        text:
                            'If you delete your User Contributions from the Platform, copies of your User Contributions may remain viewable in cached and archived pages, or might have been copied or stored by other Platform users.'),
                    Text(
                      "Other Privacy Rights Based on Residency",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'If you are a California resident or a resident of another state with specific data privacy laws, applicable law may provide you with additional rights regarding our use of your personal information. To learn more about California privacy rights, please contact us.'),
                    DesignWidgets.getParagraph(
                        text:
                            "In addition, California's 'Shine the Light' law (Civil Code Section 1798.83) permits users of our Platform that are California residents to request certain information regarding our disclosure of personal information to third parties for their direct marketing purposes. To make such a request, please contact us."),
                    Text(
                      "Data Security",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            'We have implemented measures designed to secure your personal information from accidental loss and from unauthorized access, use, alteration, and disclosure. The safety and security of your information also depends on you. Where we have given you (or where you have chosen) a password for access to certain parts of our Platform, you are responsible for keeping this password confidential. We ask you not to share your password with anyone. We urge you to be careful about giving out information in public areas of the Platform like message boards. The information you share in public areas may be viewed by any user of the Platform.'),
                    DesignWidgets.getParagraph(
                        text:
                            "Unfortunately, the transmission of information via the internet and mobile platforms is not completely secure. Although we strive to protect your personal information, we cannot guarantee the security of your personal information transmitted through our Platform. Any transmission of personal information is at your own risk. We are not responsible for circumvention of any privacy settings or security measures we provide."),
                    DesignWidgets.getParagraph(
                        text:
                            "Without limiting the foregoing, we will securely erase from hard disks, magnetic tapes, solid state memory, and other devices all player information before we dispose of same."),
                    Text(
                      "Changes to Our Privacy Policy",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            "We may update our privacy policy from time to time. If we make material changes to how we treat our users' personal information, we will post the new privacy policy on this page. The date the privacy policy was last revised is identified at the top of the page. You are responsible for ensuring we have an up-to-date active and deliverable email address for you and for periodically visiting this privacy policy to check for any changes."),
                    Text(
                      "Contact Information",
                      style: CustomStyles.legalHeading,
                    ),
                    DesignWidgets.addVerticalSpace(12.0),
                    DesignWidgets.getParagraph(
                        text:
                            "To ask questions or comment about this privacy policy and our privacy practices, contact us info@clickclinician.com."),
                    DesignWidgets.getParagraph(
                        text:
                            "In addition, to exercise any opt-out, access, data portability or deletion rights under applicable law, please submit a verifiable consumer request in writing to us at info@clickclinician.com."),
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

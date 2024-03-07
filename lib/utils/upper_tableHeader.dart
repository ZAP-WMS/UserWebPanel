import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/style.dart';

TextEditingController dateController = TextEditingController();

// Widget upperHeader(
//     String tabletitle, TextEditingController Controller, BuildContext context) {
//   return
//    Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         border: Border.all(color: blue),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/applogo/logo.png',
//             height: 50,
//             fit: BoxFit.fitWidth,
//           ),
//           Divider(
//             color: blue,
//             thickness: 2,
//           ),
//           Text(
//             tabletitle,
//             style: tableTitleStyle,
//           ),
//           Divider(
//             color: blue,
//             thickness: 2,
//           ),
//           Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   customText('Date:', '05/07/2000', Controller, context),
//                   customText('Time:', '01:01:00', Controller, context),
//                 ],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   customText('Document Reference Number:', 'doc1234',
//                       dateController, context),
//                   customText('Bus Depot Name:', 'BBM', dateController, context)
//                 ],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   customText(
//                       'TPEVCSL/E-BUS/Delhi:', '', dateController, context),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width * 0.03,
//                   )
//                 ],
//               ),
//             ],
//           ),

//           // const SizedBox(height: 10),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     customText('Time:', dateController),
//           //     customText('Bus Depot Name :', dateController),
//           //     SizedBox(
//           //       width: MediaQuery.of(context).size.width * 0.31,
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     ),
//   );
// }

Widget customText(
    String title,
    String hintText,
    TextEditingController controller,
    TextInputType inputType,
    List<TextInputFormatter> inputformatter,
    BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width * 0.17,
          child: Text(
            title,
            style: tableheader,
          )),
      Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          style: formtext,
          keyboardType: inputType,
          inputFormatters: inputformatter,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: tablefonttext,
              contentPadding: const EdgeInsets.only(left: 2, right: 2)),
          controller: controller,
        ),
      ),
    ],
  );
}

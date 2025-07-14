import 'package:chat_app_flutter_firebase/firebase_options.dart';
import 'package:chat_app_flutter_firebase/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main()async
 {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// import 'package:chat_app_flutter_firebase/screens/material%20ui.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material 3 Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         useMaterial3: true,
//       ),
//       home: HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // void main() => runApp(MyApp());

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       themeMode: ThemeMode.system,
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
// //         useMaterial3: true,
// //         textTheme: GoogleFonts.poppinsTextTheme(),
// //       ),
// //       darkTheme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: Colors.deepPurple,
// //           brightness: Brightness.dark,
// //         ),
// //         useMaterial3: true,
// //         textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
// //       ),
// //       home: HomeScreen(),
// //     );
// //   }
// // }

// // class HomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final colorScheme = Theme.of(context).colorScheme;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Material 3 UI Starter', style: GoogleFonts.poppins()),
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Card(
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //               child: ListTile(
// //                 title: Text('Material 3 Card', style: GoogleFonts.poppins()),
// //                 subtitle: Text('Built with default M3 theme'),
// //               ),
// //             ).animate().fadeIn().slideY(),
// //             SizedBox(height: 20),
// //             Container(
// //               padding: EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [Colors.purple, Colors.indigo],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.indigoAccent.withOpacity(0.4),
// //                     blurRadius: 20,
// //                     offset: Offset(0, 8),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("Futuristic Panel",
// //                       style: GoogleFonts.orbitron(
// //                         fontSize: 22,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       )),
// //                   SizedBox(height: 10),
// //                   Text("Gradient, animation & M3", style: TextStyle(color: Colors.white70)),
// //                 ],
// //               ),
// //             ).animate().fadeIn(delay: 300.ms),
// //             SizedBox(height: 20),
// //             FilledButton(
// //               onPressed: () {},
// //               style: ButtonStyle(
// //                 backgroundColor: MaterialStateProperty.all(colorScheme.primary),
// //               ),
// //               child: Text('Material 3 Button')
// //                   .animate()
// //                   .scale()
// //                   .fadeIn(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

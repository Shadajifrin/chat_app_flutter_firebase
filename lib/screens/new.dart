import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: NeumorphicThemeData(
        baseColor: Colors.grey,
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.grey,
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = NeumorphicTheme.isUsingDark(context);

    return NeumorphicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Combined UI Starter', style: GoogleFonts.poppins()),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 8,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                  color: isDark ? Colors.grey[850] : Colors.grey[300],
                ),
                child: ListTile(
                  title: Text('Neumorphic Card', style: GoogleFonts.poppins()),
                  subtitle: Text('Soft UI powered by flutter_neumorphic'),
                ),
              ).animate().fadeIn().slideY(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigoAccent.withOpacity(0.5),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Futuristic Panel",
                        style: GoogleFonts.orbitron(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    SizedBox(height: 10),
                    Text("With gradients and shadows",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      isDark ? Colors.deepPurple : Colors.indigo),
                ),
                child: Text('Material 3 Styled Button')
                    .animate()
                    .scale()
                    .fadeIn(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
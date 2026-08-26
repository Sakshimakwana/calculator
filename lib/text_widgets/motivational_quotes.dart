import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationalQuotes extends StatelessWidget {
  const MotivationalQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          'Motivational Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Align(
            alignment: Alignment.center,
            child:  RichText(
                textAlign: TextAlign.start,

                text: TextSpan(

                  text: 'Daily ',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                  children: [
                  TextSpan(
                  text:  'Motivation',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                  ]
              ),
              ),
            ),

            SizedBox(height: 10),

              Text(
                'Believe in yourself and keep moving forward.',
                textAlign: TextAlign.end,
                style: GoogleFonts.notoSansOldItalic(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),

              ),

              const SizedBox(height: 70),

               Text(
                '“Believe you can and you are halfway there.”',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
                '— Theodore Roosevelt',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ),

              const SizedBox(height: 70),

               Text(
                '“Success is not final, failure is not fatal.”',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
                '— Winston Churchill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ),

              const SizedBox(height: 70),

               Text(
                ' “Time is too slow for those who wait, too swift for those who fear, '
                    'too long for those who grieve, too short for those who rejoice, '
                    'but for those who love, time is eternity.”',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:GoogleFonts.merriweather(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
                '— Mahatma Gandhi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ),

              const SizedBox(height: 140),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: 'Keep ',
                    ),
                    TextSpan(
                      text: 'Going',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' • Stay ',
                    ),
                    TextSpan(
                      text: 'Positive',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' • Never ',
                    ),
                    TextSpan(
                      text: 'Give Up',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
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